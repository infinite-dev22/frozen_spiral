import 'package:flutter/material.dart';
import 'package:smart_case/models/smart_currency.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_dropdowns.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:toast/toast.dart';

import '../../models/smart_file.dart';
import '../../models/smart_requisition.dart';
import '../../models/user.dart';
import '../../services/apis/smartcase_api.dart';
import '../../theme/color.dart';
import '../../util/smart_case_init.dart';
import '../../widgets/custom_searchable_async_bottom_sheet_contents.dart';
import '../../widgets/form_title.dart';

class RequisitionForm extends StatefulWidget {
  const RequisitionForm({
    super.key,
    this.onSave,
    required this.currencies,
  });

  final Function()? onSave;
  final List<SmartCurrency> currencies;

  @override
  State<RequisitionForm> createState() => _RequisitionFormState();
}

class _RequisitionFormState extends State<RequisitionForm> {
  final globalKey = GlobalKey();
  final ToastContext toast = ToastContext();

  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<SmartFile> files = List.empty(growable: true);
  List<SmartUser> approvers = List.empty(growable: true);
  List<SmartRequisitionCategory> categories = List.empty(growable: true);
  int financialStatus = 0;

  SmartFile? file;
  SmartCurrency? currency;
  SmartUser? approver;
  SmartRequisitionCategory? category;

  @override
  Widget build(BuildContext context) {
    toast.init(context);

    return _buildBody();
  }

  _buildBody() {
    return Column(
      children: [
        FormTitle(
          name: 'New Requisition',
          onSave: _submitFormData,
        ),
        Expanded(
          child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                FocusManager.instance.primaryFocus?.unfocus();
                return true;
              }
              return false;
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DateAccordion(
                  dateController: dateController,
                ),
                CustomDropdown<SmartCurrency>(
                    hintText: 'currency',
                    menuItems: widget.currencies,
                    defaultValue: widget.currencies
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
                      value: financialStatus.toString(),
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
                CustomDropdown<SmartUser>(
                  hintText: 'approver',
                  menuItems: approvers,
                  onChanged: _onTapSearchedApprover,
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
                    height: 300 /* MediaQuery.of(context).viewInsets.bottom */),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _showSearchFileBottomSheet() {
    List<SmartFile> searchedList = List.empty(growable: true);
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
                hint: "Search file",
                list: searchedList,
                onTap: (value) {
                  file = null;
                  _onTapSearchedFile(value!);
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      if (files.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(files.where((smartFile) => smartFile
                            .getName()
                            .toLowerCase()
                            .contains(value.toLowerCase())));
                      } else {
                        _loadFiles();
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

  _loadFiles() async {
    files = await SmartCaseApi.fetchAllFiles(currentUser.token);
    setState(() {});
  }

  _loadApprovers() async {
    Map usersMap =
        await SmartCaseApi.smartFetch('api/hr/employees', currentUser.token);

    List? users = usersMap['search']['employees'];
    setState(() {
      approvers = users!.map((doc) => SmartUser.fromJson(doc)).toList();
      users = null;
    });
  }

  _loadCategories() async {
    Map categoriesMap = await SmartCaseApi.smartFetch(
        'api/admin/requisitionCategory', currentUser.token);

    List? categories = categoriesMap['requisitionCategory'];
    setState(() {
      this.categories = categories!
          .map((doc) => SmartRequisitionCategory.fromJson(doc))
          .toList();
      categories = null;
    });
  }

  _loadFileFinancialStatus() async {
    Map financialStatusMap = await SmartCaseApi.smartFetch(
        'api/cases/${file!.getId()}/contactsandfinancialstatus/',
        currentUser.token);

    int? financialStatus = financialStatusMap['caseFinancialStatus'];
    setState(() {
      this.financialStatus = financialStatus!;
      financialStatus = null;
    });
  }

  _onTapSearchedFile(SmartFile value) {
    setState(() {
      file = value;
      _loadApprovers();
      _loadFileFinancialStatus();
    });
  }

  _onTapSearchedCurrency(SmartCurrency? value) {
    setState(() {
      currency = value;
    });
  }

  _onTapSearchedApprover(SmartUser? value) {
    setState(() {
      approver = value;
    });
  }

  _onTapSearchedCategory(SmartRequisitionCategory value) {
    setState(() {
      category = value;
    });
  }

  @override
  void initState() {
    _loadFiles();
    _loadApprovers();
    _loadCategories();

    super.initState();
  }

  _submitFormData() {
    SmartRequisition smartRequisition = SmartRequisition(
      date: dateController.text.trim(),
      amounts: [amountController.text.trim()],
      payoutAmount: financialStatus.toString(),
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

    SmartCaseApi.smartPost(
      'api/accounts/cases/${file!.getId()}/requisitions',
      currentUser.token,
      smartRequisition.toJson(),
      onError: () {
        Toast.show("An error occurred",
            duration: Toast.lengthLong, gravity: Toast.bottom);
      },
      onSuccess: () {
        Toast.show("Requisition added successfully",
            duration: Toast.lengthLong, gravity: Toast.bottom);
        Navigator.pop(context);
      },
    );
  }
}
