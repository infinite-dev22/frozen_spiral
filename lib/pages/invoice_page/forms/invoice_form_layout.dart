import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/bank/bank_model.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/database/invoice/invoice_type_model.dart';
import 'package:smart_case/pages/invoice_page/forms/invoice_items_form.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_add_items_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_amounts_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_terms_widget.dart';
import 'package:smart_case/services/apis/smartcase_apis/bank_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/file_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_approver_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_type_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_dropdowns.dart';
import 'package:smart_case/widgets/custom_searchable_async_bottom_sheet_contents.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/form_title.dart';

class InvoiceFormLayout extends StatefulWidget {
  final SmartInvoice? invoice;
  final List<SmartCurrency> currencies;

  const InvoiceFormLayout({
    super.key,
    this.invoice,
    required this.currencies,
  });

  @override
  State<InvoiceFormLayout> createState() => _InvoiceFormLayoutState();
}

class _InvoiceFormLayoutState extends State<InvoiceFormLayout> {
  SmartFile? file;
  SmartCurrency? currency;
  SmartInvoiceType? invoiceType;
  SmartBank? bank;
  SmartEmployee? approver;

  final globalKey = GlobalKey();
  bool isTitleElevated = false;
  bool isActivityLoading = false;

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    final SingleValueDropDownController approversController =
        SingleValueDropDownController(
            data: approver != null
                ? DropDownValueModel(value: approver, name: approver!.getName())
                : null);
    final SingleValueDropDownController invoiceTypeController =
        SingleValueDropDownController(
            data: invoiceType != null
                ? DropDownValueModel(
                    value: invoiceType, name: invoiceType!.getName())
                : null);
    final SingleValueDropDownController bankController =
        SingleValueDropDownController(
            data: bank != null
                ? DropDownValueModel(value: bank, name: bank!.getName())
                : null);

    return Column(
      children: [
        FormTitle(
          name: '${(file == null) ? 'New' : 'Edit'} Invoice',
          onSave: () => _submitFormData(),
          isElevated: isTitleElevated,
          addButtonText: (file == null) ? 'Add' : 'Update',
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
                padding: const EdgeInsets.all(8),
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    return Form(
                      child: Column(
                        children: [
                          SearchableDropDown<SmartInvoiceType>(
                            hintText: 'invoice type',
                            menuItems: preloadedInvoiceTypes.toSet().toList(),
                            onChanged: (value) {
                              _onTapSearchedInvoiceType(
                                  invoiceTypeController.dropDownValue?.value);
                            },
                            defaultValue: invoiceType,
                            controller: invoiceTypeController,
                          ),
                          // GestureDetector(
                          //   onTap: _showSearchInvoiceTypeBottomSheet,
                          //   child: Container(
                          //     height: 50,
                          //     width: double.infinity,
                          //     padding: const EdgeInsets.all(5),
                          //     margin: const EdgeInsets.only(bottom: 10),
                          //     alignment: Alignment.centerLeft,
                          //     decoration: BoxDecoration(
                          //       color: AppColors.white,
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment:
                          //       MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Padding(
                          //           padding: const EdgeInsets.all(6),
                          //           child: SizedBox(
                          //             width: constraints.maxWidth - 50,
                          //             child: Text(
                          //               invoiceType?.getName() ??
                          //                   'Select invoice type',
                          //               style: const TextStyle(
                          //                   overflow: TextOverflow.ellipsis,
                          //                   color: AppColors.darker,
                          //                   fontSize: 15,
                          //                   fontWeight: FontWeight.w500),
                          //             ),
                          //           ),
                          //         ),
                          //         const Icon(
                          //           Icons.keyboard_arrow_down_rounded,
                          //           color: AppColors.darker,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          InvoiceDateTimeAccordion(
                            startName: 'Date',
                            endName: 'Due on',
                            startDateController: startDateController,
                            endDateController: endDateController,
                          ),
                          GestureDetector(
                            onTap: _showSearchFileBottomSheet,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(bottom: 10),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: SizedBox(
                                      width: constraints.maxWidth - 50,
                                      child: Text(
                                        file?.fileName ?? 'Select file',
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: AppColors.darker,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.darker,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (file != null)
                            Column(
                              children: [
                                CustomTextArea(
                                  hint: "Client",
                                  value: file!.clientName!,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          CustomGenericDropdown<SmartCurrency>(
                            hintText: 'currency',
                            menuItems: widget.currencies,
                            defaultValue: (widget.currencies.isNotEmpty)
                                ? (currency != null)
                                    ? widget.currencies.firstWhere(
                                        (cur) => cur.code == currency!.code)
                                    : widget.currencies.firstWhere(
                                        (currency) => currency.code == 'UGX')
                                : null,
                            onChanged: _onTapSearchedCurrency,
                          ),
                          InvoiceAddItemsWidget(onTap: _showItemsDialog),
                          InvoiceAmountsWidget(),
                          SearchableDropDown<SmartBank>(
                            hintText: 'bank',
                            menuItems: preloadedBanks.toSet().toList(),
                            onChanged: (value) {
                              _onTapSearchedBank(
                                  bankController.dropDownValue?.value);
                            },
                            defaultValue: bank,
                            controller: bankController,
                          ),
                          // GestureDetector(
                          //   onTap: _showSearchBankBottomSheet,
                          //   child: Container(
                          //     height: 50,
                          //     width: double.infinity,
                          //     padding: const EdgeInsets.all(5),
                          //     margin: const EdgeInsets.only(bottom: 10),
                          //     alignment: Alignment.centerLeft,
                          //     decoration: BoxDecoration(
                          //       color: AppColors.white,
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Padding(
                          //           padding: const EdgeInsets.all(6),
                          //           child: SizedBox(
                          //             width: constraints.maxWidth - 50,
                          //             child: Text(
                          //               bank?.getName() ?? 'Select bank',
                          //               style: const TextStyle(
                          //                   overflow: TextOverflow.ellipsis,
                          //                   color: AppColors.darker,
                          //                   fontSize: 15,
                          //                   fontWeight: FontWeight.w500),
                          //             ),
                          //           ),
                          //         ),
                          //         const Icon(
                          //           Icons.keyboard_arrow_down_rounded,
                          //           color: AppColors.darker,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          if (bank != null)
                            Column(
                              children: [
                                CustomTextArea(
                                  hint: "Bank description",
                                  value: bank!.description!,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          // GestureDetector(
                          //   onTap: _showSearchApproverBottomSheet,
                          //   child: Container(
                          //     height: 50,
                          //     width: double.infinity,
                          //     padding: const EdgeInsets.all(5),
                          //     margin: const EdgeInsets.only(bottom: 10),
                          //     alignment: Alignment.centerLeft,
                          //     decoration: BoxDecoration(
                          //       color: AppColors.white,
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Padding(
                          //           padding: const EdgeInsets.all(6),
                          //           child: SizedBox(
                          //             width: constraints.maxWidth - 50,
                          //             child: Text(
                          //               file?.fileName ?? 'Select approver',
                          //               style: const TextStyle(
                          //                   overflow: TextOverflow.ellipsis,
                          //                   color: AppColors.darker,
                          //                   fontSize: 15,
                          //                   fontWeight: FontWeight.w500),
                          //             ),
                          //           ),
                          //         ),
                          //         const Icon(
                          //           Icons.keyboard_arrow_down_rounded,
                          //           color: AppColors.darker,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          if (preloadedApprovers.isNotEmpty)
                            SearchableDropDown<SmartEmployee>(
                              hintText: 'approver',
                              menuItems: preloadedApprovers.toSet().toList(),
                              onChanged: (value) {
                                _onTapSearchedApprover(
                                    approversController.dropDownValue?.value);
                              },
                              defaultValue: approver,
                              controller: approversController,
                            ),
                          InvoiceTermsWidget(),
                          const SizedBox(height: 300),
                        ],
                      ),
                    );
                  }),
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
                  setState(() {
                    file = null;
                    _onTapSearchedFile(value!);
                  });
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      if (preloadedFiles.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(preloadedFiles.where((smartFile) =>
                            smartFile
                                .getName()
                                .toLowerCase()
                                .contains(value.toLowerCase())));
                      } else {
                        _reloadFiles();
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

  _showSearchInvoiceTypeBottomSheet() {
    List<SmartInvoiceType> searchedList = List.empty(growable: true);
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
                hint: "Search invoice type",
                list: searchedList,
                onTap: (value) {
                  setState(() {
                    invoiceType = null;
                    _onTapSearchedInvoiceType(value!);
                  });
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      if (preloadedInvoiceTypes.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(preloadedInvoiceTypes.where(
                            (smartInvoiceType) => smartInvoiceType
                                .getName()
                                .toLowerCase()
                                .contains(value.toLowerCase())));
                      } else {
                        _reloadInvoiceTypes();
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

  _showSearchBankBottomSheet() {
    List<SmartBank> searchedList = List.empty(growable: true);
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
                hint: "Search bank",
                list: searchedList,
                onTap: (value) {
                  setState(() {
                    bank = null;
                    _onTapSearchedBank(value!);
                  });
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      if (preloadedBanks.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(preloadedBanks.where((smartBank) =>
                            smartBank
                                .getName()
                                .toLowerCase()
                                .contains(value.toLowerCase())));
                      } else {
                        _reloadBanks();
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

  // _showSearchApproverBottomSheet() {
  //   List<SmartEmployee> searchedList = List.empty(growable: true);
  //   bool isLoading = false;
  //   return showModalBottomSheet(
  //       isScrollControlled: true,
  //       constraints: BoxConstraints.expand(
  //           height: MediaQuery.of(context).size.height * .8),
  //       context: context,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return AsyncSearchableBottomSheetContents(
  //               hint: "Search approver",
  //               list: searchedList,
  //               onTap: (value) {
  //                 setState(() {
  //                   approver = null;
  //                   _onTapSearchedApprover(value!);
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               onSearch: (value) {
  //                 setState(() {
  //                   searchedList.clear();
  //                   if (value.length > 2) {
  //                     if (preloadedApprovers.isNotEmpty) {
  //                       isLoading = false;
  //                       searchedList.addAll(preloadedApprovers.where((smartApprover) =>
  //                           smartApprover
  //                               .getName()
  //                               .toLowerCase()
  //                               .contains(value.toLowerCase())));
  //                     } else {
  //                       _reloadApprovers();
  //                       isLoading = true;
  //                     }
  //                   }
  //                 });
  //               },
  //               isLoading: isLoading,
  //             );
  //           },
  //         );
  //       });
  // }

  _reloadApprovers() async {
    await InvoiceApproverApi.fetchAll();
  }

  _reloadBanks() async {
    await BankApi.fetchAll();
  }

  _reloadInvoiceTypes() async {
    await InvoiceTypeApi.fetchAll();
  }

  _reloadFiles() async {
    await FileApi.fetchAll();
  }

  _onTapSearchedApprover(SmartEmployee value) {
    setState(() {
      approver = value;
    });
  }

  _onTapSearchedBank(SmartBank value) {
    setState(() {
      bank = value;
    });
  }

  _onTapSearchedInvoiceType(SmartInvoiceType value) {
    setState(() {
      invoiceType = value;
    });
  }

  _onTapSearchedFile(SmartFile value) {
    setState(() {
      file = value;
    });
  }

  _fillDataForUpdate() {
    if (widget.invoice != null) {
      file = widget.invoice!.file!;
    }
  }

  _onTapSearchedCurrency(SmartCurrency? value) {
    setState(() {
      currency = value;
    });
  }

  _fillFormsForEdit() {
    if (widget.invoice != null) {
      currency = widget.invoice!.currency;
      file = widget.invoice!.file;
    }
  }

  _submitFormData() {
    SmartInvoice smartInvoice = SmartInvoice();

    // (widget.invoice == null)
    //     ? InvoiceApi.post(
    //   smartInvoice.createInvoiceToJson(),
    //   file!.getId(),
    //   onError: () {
    //     Fluttertoast.showToast(
    //         msg: "An error occurred",
    //         toastLength: Toast.LENGTH_LONG,
    //         gravity: ToastGravity.CENTER,
    //         timeInSecForIosWeb: 5,
    //         backgroundColor: AppColors.red,
    //         textColor: AppColors.white,
    //         fontSize: 16.0);
    //   },
    //   onSuccess: () {
    //     Fluttertoast.showToast(
    //         msg: "Invoice added successfully",
    //         toastLength: Toast.LENGTH_LONG,
    //         gravity: ToastGravity.CENTER,
    //         timeInSecForIosWeb: 5,
    //         backgroundColor: AppColors.green,
    //         textColor: AppColors.white,
    //         fontSize: 16.0);
    //   },
    // )
    //     : SmartCaseApi.smartPut(
    //   'api/accounts/invoices/${widget.invoice!.id}/update',
    //   currentUser.token,
    //   smartInvoice.createInvoiceToJson(),
    //   onError: () {
    //     Fluttertoast.showToast(
    //         msg: "An error occurred",
    //         toastLength: Toast.LENGTH_LONG,
    //         gravity: ToastGravity.CENTER,
    //         timeInSecForIosWeb: 5,
    //         backgroundColor: AppColors.red,
    //         textColor: AppColors.white,
    //         fontSize: 16.0);
    //   },
    //   onSuccess: () {
    //     Fluttertoast.showToast(
    //         msg: "Invoice updated successfully",
    //         toastLength: Toast.LENGTH_LONG,
    //         gravity: ToastGravity.CENTER,
    //         timeInSecForIosWeb: 5,
    //         backgroundColor: AppColors.green,
    //         textColor: AppColors.white,
    //         fontSize: 16.0);
    //   },
    // );

    Navigator.pop(context);
  }

  _showItemsDialog() {
    return showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height * .8),
      context: context,
      builder: (context) => InvoiceItemsForm(),
    );
  }

  @override
  void initState() {
    super.initState();
    _reloadBanks();
    _reloadApprovers();
    _fillDataForUpdate();
  }
}
