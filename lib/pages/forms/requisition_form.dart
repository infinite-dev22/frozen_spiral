import 'package:flutter/material.dart';
import 'package:smart_case/models/smart_currency.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

import '../../models/smart_file.dart';
import '../../models/smart_requisition.dart';
import '../../models/user.dart';
import '../../services/apis/smartcase_api.dart';
import '../../theme/color.dart';
import '../../util/smart_case_init.dart';
import '../../widgets/custom_searchable_async_bottom_sheet_contents.dart';

class RequisitionForm extends StatefulWidget {
  const RequisitionForm({
    super.key,
    this.onSave,
  });

  final Function()? onSave;

  @override
  State<RequisitionForm> createState() => _RequisitionFormState();
}

class _RequisitionFormState extends State<RequisitionForm> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<SmartCurrency> currencies = List.empty(growable: true);
  List<SmartFile> files = List.empty(growable: true);
  List<SmartUser> approvers = List.empty(growable: true);
  List<SmartRequisitionCategory> categories = List.empty(growable: true);

  SmartFile? file;
  SmartCurrency? currency;
  SmartUser? approver;
  SmartRequisitionCategory? category;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Expanded(
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
                onPressed: _showSearchCurrencyBottomSheet,
                child: Text(
                  currency?.getName() ?? 'Select currency',
                ),
              ),
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
                onPressed: _showSearchFileBottomSheet,
                child: Text(
                  file?.getName() ?? 'Select file',
                ),
              ),
            ),
            if (file != null)
              const SmartText(
                  value: '\$100,000 (Dummy data)',
                  icon: Icons.arrow_upward_rounded,
                  color: AppColors.green),
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
                onPressed: _showSearchApproverBottomSheet,
                child: Text(
                  approver?.getName() ?? 'Select approver',
                ),
              ),
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
            SmartCaseTextField(hint: 'Amount', controller: amountController),
            CustomTextArea(
                hint: 'Description', controller: descriptionController),
          ],
        ),
      ),
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

  _showSearchCurrencyBottomSheet() {
    List<SmartCurrency> searchedList = List.empty(growable: true);
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
                hint: "Search currency",
                list: searchedList,
                onTap: (value) {
                  _onTapSearchedCurrency(value!);
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      if (currencies.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(currencies.where((smartCurrency) =>
                            smartCurrency
                                .getName()
                                .toLowerCase()
                                .contains(value.toLowerCase())));
                      } else {
                        _loadCurrencies();
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

  _showSearchApproverBottomSheet() {
    List<SmartUser> searchedList = List.empty(growable: true);
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
                hint: "Search approvers",
                list: searchedList,
                onTap: (value) {
                  _onTapSearchedApprover(value!);
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      if (approvers.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(approvers.where((smartApprover) =>
                            smartApprover
                                .getName()
                                .toLowerCase()
                                .contains(value.toLowerCase())));
                      } else {
                        _loadApprovers();
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

  _loadCurrencies() async {
    Map currencyMap = await SmartCaseApi.smartFetch(
        'api/admin/currencytypes', currentUser.token);
    List? currencyList = currencyMap["currencytypes"];
    setState(() {
      currencies =
          currencyList!.map((doc) => SmartCurrency.fromJson(doc)).toList();
      currencyList = null;
    });
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

  _onTapSearchedFile(SmartFile value) {
    setState(() {
      file = value;
      _loadApprovers();
    });
  }

  _onTapSearchedCurrency(SmartCurrency value) {
    setState(() {
      currency = value;
    });
  }

  _onTapSearchedApprover(SmartUser value) {
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
    _loadCurrencies();
    _loadApprovers();
    _loadCategories();

    super.initState();
  }
}
