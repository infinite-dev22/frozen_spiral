import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/models/smart_currency.dart';
import 'package:smart_case/models/smart_employee.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_dropdowns.dart';
import 'package:smart_case/widgets/custom_searchable_async_bottom_sheet_contents.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/form_title.dart';
import 'package:toast/toast.dart';

import '../../services/apis/smartcase_apis/file_api.dart';
import '../../widgets/better_toast.dart';

class RequisitionForm extends StatefulWidget {
  const RequisitionForm({
    super.key,
    this.onSave,
    required this.currencies,
    this.requisition,
  });

  final SmartRequisition? requisition;
  final Function()? onSave;
  final List<SmartCurrency> currencies;

  @override
  State<RequisitionForm> createState() => _RequisitionFormState();
}

class _RequisitionFormState extends State<RequisitionForm> {
  final globalKey = GlobalKey();
  final ToastContext toast = ToastContext();
  bool isTitleElevated = false;
  bool isActivityLoading = false;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<SmartFile> files = List.empty(growable: true);
  List<SmartEmployee> approvers = List.empty(growable: true);
  List<SmartRequisitionCategory> categories = List.empty(growable: true);
  int financialStatus = 0;

  NumberFormat formatter = NumberFormat('###,###,###,###,###,###,###,###,###');

  SmartFile? file;
  SmartCurrency? currency;
  SmartEmployee? approver;
  SmartRequisitionCategory? category;

  @override
  Widget build(BuildContext context) {
    toast.init(context);

    return _buildBody();
  }

  _buildBody() {
    final ScrollController scrollController = ScrollController();
    final SingleValueDropDownController approversController =
        SingleValueDropDownController(
            data: approver != null
                ? DropDownValueModel(value: approver, name: approver!.getName())
                : null);

    return Column(
      children: [
        FormTitle(
          name: '${(widget.requisition == null) ? 'New' : 'Edit'} Requisition',
          onSave: () => _submitFormData(),
          isElevated: isTitleElevated,
          addButtonText: (widget.requisition == null) ? 'Add' : 'Update',
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollController.position.userScrollDirection ==
                    ScrollDirection.reverse) {
                  setState(() {
                    isTitleElevated = true;
                  });
                } else if (scrollController.position.userScrollDirection ==
                    ScrollDirection.forward) {
                  if (scrollController.position.pixels ==
                      scrollController.position.maxScrollExtent) {
                    setState(() {
                      isTitleElevated = false;
                    });
                  }
                }
                return true;
              },
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  DateAccordion(
                    dateController: dateController,
                  ),
                  CustomGenericDropdown<SmartCurrency>(
                      hintText: 'currency',
                      menuItems: widget.currencies,
                      defaultValue: currency ??
                          widget.currencies
                              .firstWhere((currency) => currency.code == 'UGX'),
                      onChanged: _onTapSearchedCurrency),
                  Container(
                    height: 50,
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: _showSearchFileBottomSheet,
                      child: Text(
                        file?.getName() ?? 'Select file',
                      ),
                    ),
                  ),
                  if (file != null)
                    SmartText(
                        value: formatter.format(financialStatus).toString(),
                        icon: (financialStatus > 0)
                            ? Icons.arrow_upward_rounded
                            : (financialStatus < 0)
                                ? Icons.arrow_downward_rounded
                                : Icons.circle_outlined,
                        color: (financialStatus > 0)
                            ? AppColors.green
                            : (financialStatus < 0)
                                ? AppColors.red
                                : AppColors.blue),
                  SearchableDropDown<SmartEmployee>(
                    hintText: 'approver',
                    menuItems: approvers.toSet().toList(),
                    onChanged: (value) {
                      _onTapSearchedApprover(
                          approversController.dropDownValue?.value);
                    },
                    defaultValue: approver,
                    controller: approversController,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: _showSearchCategoryBottomSheet,
                      child: Text(
                        category?.getName() ?? 'Select requisition category',
                      ),
                    ),
                  ),
                  SmartCaseNumberField(
                      hint: 'Amount', controller: amountController),
                  CustomTextArea(
                    key: globalKey,
                    hint: 'Description',
                    controller: descriptionController,
                    onTap: () {
                      Scrollable.ensureVisible(globalKey.currentContext!);
                    },
                  ),
                  const SizedBox(
                      height:
                          300 /* MediaQuery.of(context).viewInsets.bottom */),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showSearchFileBottomSheet() {
    List<SmartFile> searchedList = List.empty(growable: true);
    return showModalBottomSheet(
        isScrollControlled: true,
        constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height * .8),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AsyncSearchableBottomSheetContents(
                hint: "Search file",
                list: searchedList,
                onTap: (value) {
                  file = null;
                  _onTapSearchedFile(value!);
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  searchedList.clear();
                  if (value.length > 2) {
                    if (files.isNotEmpty) {
                      isActivityLoading = false;
                      searchedList.addAll(files.where((smartFile) => smartFile
                          .getName()
                          .toLowerCase()
                          .contains(value.toLowerCase())));
                      setState(() {});
                    } else {
                      _reloadFiles();
                      isActivityLoading = true;
                    }
                  }
                },
                isLoading: isActivityLoading,
              );
            },
          );
        });
  }

  _showSearchCategoryBottomSheet() {
    List<SmartRequisitionCategory> searchedList = List.empty(growable: true);
    bool isLoading = false;
    return showModalBottomSheet(
        isScrollControlled: true,
        constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height * .8),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AsyncSearchableBottomSheetContents(
                hint: "Search categories",
                list: searchedList,
                onTap: (value) {
                  _onTapSearchedCategory(value!);
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      if (categories.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(categories.where((smartCategory) =>
                            smartCategory
                                .getName()
                                .toLowerCase()
                                .contains(value.toLowerCase())));
                      } else {
                        _loadCategories();
                        setState(() {});
                        isLoading = true;
                      }
                    }
                  });
                },
                isLoading: isLoading,
              );
            },
          );
        });
  }

  _reloadFiles() async {
    files = await FileApi.fetchAll();
    setState(() {});
  }

  _loadFiles() async {
    files = await FileApi.fetchAll();
  }

  _loadApprovers() async {
    Map usersMap = await SmartCaseApi.smartFetch(
        'api/hr/employees/requisitionApprovers', currentUser.token);

    List users = usersMap['search']['employees'];

    approvers = users.map((doc) => SmartEmployee.fromJson(doc)).toList();
  }

  _loadCategories() async {
    Map categoriesMap = await SmartCaseApi.smartFetch(
        'api/admin/requisitionCategory', currentUser.token);

    List? categories = categoriesMap['requisitionCategory'];

    this.categories = categories!
        .map((doc) => SmartRequisitionCategory.fromJson(doc))
        .toList();
    categories = null;
  }

  _loadFileFinancialStatus() async {
    Map financialStatusMap = await SmartCaseApi.smartFetch(
        'api/cases/${file!.getId()}/contactsandfinancialstatus/',
        currentUser.token);

    int financialStatus = financialStatusMap['caseFinancialStatus'];

    this.financialStatus = financialStatus;
    setState(() {});
  }

  _onTapSearchedFile(SmartFile value) {
    setState(() {
      file = value;
    });
    _loadFileFinancialStatus();
  }

  _onTapSearchedCurrency(SmartCurrency? value) {
    setState(() {
      currency = value;
    });
  }

  _onTapSearchedApprover(SmartEmployee? value) {
    setState(() {
      approver = value;
    });
  }

  _onTapSearchedCategory(SmartRequisitionCategory value) {
    setState(() {
      category = value;
    });
  }

  _fillFormsForEdit() {
    if (widget.requisition != null) {
      dateController.text =
          DateFormat('dd/MM/yyyy').format(widget.requisition!.date!);
      currency = widget.requisition!.currency;
      file = widget.requisition!.caseFile;
      approver = widget.requisition!.supervisor;
      category = widget.requisition!.requisitionCategory!;
      amountController.text =
          formatter.format(double.parse(widget.requisition!.amount!));
      descriptionController.text = widget.requisition!.description!;
      _loadFileFinancialStatus();
    }
  }

  @override
  void initState() {
    _loadFiles();
    _loadApprovers();
    _loadCategories();
    _fillFormsForEdit();
    currency =
        widget.currencies.firstWhere((currency) => currency.code == 'UGX');

    super.initState();
  }

  _submitFormData() {
    SmartRequisition smartRequisition = SmartRequisition(
      date: DateFormat('dd/MM/yyyy').parse(dateController.text.trim()),
      amount: amountController.text.trim(),
      amounts: [amountController.text.trim()],
      payoutAmount: amountController.toString(),
      descriptions: [
        descriptionController.text.trim(),
      ],
      employeeId: currentUser.getId(),
      supervisorId: approver!.getId(),
      requisitionStatusId: 5,
      requisitionCategoryId: category!.getId(),
      currencyId: currency!.getId(),
      requisitionCategoryIds: [
        category!.getId().toString(),
      ],
      caseFileIds: [
        file!.getId().toString(),
      ],
    );

    (widget.requisition == null)
        ? SmartCaseApi.smartPost(
            'api/accounts/cases/${file!.getId()}/requisitions',
            currentUser.token,
            smartRequisition.createRequisitionToJson(),
            onError: () {
              BetterToast(text: "An error occurred");
            },
            onSuccess: () {
              Toast.show("Requisition added successfully",
                  duration: Toast.lengthLong, gravity: Toast.bottom);
              BetterToast(text: "Requisition added successfully");
            },
          )
        : SmartCaseApi.smartPut(
            'api/accounts/cases/${file!.getId()}/requisitions/'
            '${widget.requisition!.id}',
            currentUser.token,
            smartRequisition.createRequisitionToJson(),
            onError: () {
              BetterToast(text: "An error occurred");
            },
            onSuccess: () {
              Toast.show("Requisition updated successfully",
                  duration: Toast.lengthLong, gravity: Toast.bottom);
              BetterToast(text: "Requisition updated successfully");
            },
          );

    Navigator.pop(context);
  }
}
