import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/invoice/invoice_form_item.dart';
import 'package:smart_case/database/invoice/invoice_item_model.dart';
import 'package:smart_case/database/tax/tax_type_model.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_form_item_list_item.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_item_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/tax_type_api.dart';
import 'package:smart_case/widgets/custom_dropdowns.dart';
import 'package:smart_case/widgets/custom_searchable_async_bottom_sheet_contents.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/form_title.dart';

class InvoiceItemsFormLayout extends StatefulWidget {
  final SmartInvoiceItem? smartInvoiceItem;

  const InvoiceItemsFormLayout({super.key, this.smartInvoiceItem});

  @override
  State<InvoiceItemsFormLayout> createState() => _InvoiceItemsFormLayoutState();
}

class _InvoiceItemsFormLayoutState extends State<InvoiceItemsFormLayout> {
  SmartInvoiceItem? invoiceItem;
  SmartTaxType? taxType;

  final globalKey = GlobalKey();
  bool isTitleElevated = false;
  bool isActivityLoading = false;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var thousandFormatter = NumberFormat("###,###,###,###,###.##");

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    final SingleValueDropDownController invoiceItemController =
        SingleValueDropDownController(
            data: invoiceItem != null
                ? DropDownValueModel(
                    value: invoiceItem, name: invoiceItem!.getName())
                : null);
    final SingleValueDropDownController taxTypeController =
        SingleValueDropDownController(
            data: taxType != null
                ? DropDownValueModel(value: taxType, name: taxType!.getName())
                : null);

    return Column(
      children: [
        FormTitle(
          name:
              '${(widget.smartInvoiceItem == null) ? 'New' : 'Edit'} Requisition',
          onSave: () => _submitFormData(),
          isElevated: isTitleElevated,
          addButtonText: (widget.smartInvoiceItem == null) ? 'Add' : 'Update',
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
                          SearchableDropDown<SmartInvoiceItem>(
                            hintText: 'item',
                            menuItems: preloadedInvoiceItems.toSet().toList(),
                            onChanged: (value) {
                              _onTapSearchedItem(
                                  invoiceItemController.dropDownValue?.value);
                            },
                            defaultValue: invoiceItem,
                            controller: invoiceItemController,
                          ),
                          // GestureDetector(
                          //   onTap: _showSearchItemBottomSheet,
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
                          //               invoiceItem?.getName() ?? 'Select item',
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
                          CustomTextArea(
                            hint: "Description",
                            controller: descriptionController,
                          ),
                          const SizedBox(height: 8),
                          SmartCaseNumberField(
                            hint: 'Amount',
                            controller: amountController,
                            maxLength: 14,
                            onChanged: (value) {
                              totalAmountController.text = value;
                            },
                          ),
                          SearchableDropDown<SmartTaxType>(
                            hintText: 'type of tax',
                            menuItems: preloadedTaxTypes.toSet().toList(),
                            onChanged: (value) {
                              _onTapSearchedTaxType(
                                  taxTypeController.dropDownValue?.value);
                            },
                            defaultValue: (preloadedTaxTypes.isNotEmpty)
                                ? (taxType != null)
                                    ? preloadedTaxTypes.firstWhere(
                                        (tax) => tax.code == taxType!.code)
                                    : preloadedTaxTypes.firstWhere((taxType) =>
                                        taxType.code!
                                            .toUpperCase()
                                            .contains('NIL'))
                                : null,
                            controller: taxTypeController,
                          ),
                          // GestureDetector(
                          //   onTap: _showSearchTaxTypeBottomSheet,
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
                          //               taxType?.getName() ?? 'Type of tax',
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
                          SmartCaseNumberField(
                            hint: 'Total amount',
                            controller: totalAmountController,
                            maxLength: 14,
                          ),
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

  _showSearchItemBottomSheet() {
    List<SmartInvoiceItem> searchedList = List.empty(growable: true);
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
                hint: "Search item",
                list: searchedList,
                onTap: (value) {
                  setState(() {
                    invoiceItem = null;
                    _onTapSearchedItem(value!);
                  });
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      if (preloadedInvoiceItems.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(preloadedInvoiceItems.where(
                            (item) => item
                                .getName()
                                .toLowerCase()
                                .contains(value.toLowerCase())));
                      } else {
                        _reloadInvoiceItems();
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

  _showSearchTaxTypeBottomSheet() {
    List<SmartTaxType> searchedList = List.empty(growable: true);
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
                hint: "Search type of tax",
                list: searchedList,
                onTap: (value) {
                  setState(() {
                    taxType = null;
                    _onTapSearchedTaxType(value!);
                  });
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      if (preloadedTaxTypes.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(preloadedTaxTypes.where(
                            (smartTaxType) => smartTaxType
                                .getName()
                                .toLowerCase()
                                .contains(value.toLowerCase())));
                      } else {
                        _reloadTaxTypes();
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

  _onTapSearchedItem(SmartInvoiceItem value) {
    setState(() {
      invoiceItem = value;
    });
  }

  _onTapSearchedTaxType(SmartTaxType value) {
    setState(() {
      taxType = value;
      totalAmountController.text = thousandFormatter
          .format(double.parse(
                  totalAmountController.text.replaceAll(",", "").toString()) *
              (double.parse(value.rate!)/100))
          .toString();
    });
  }

  _reloadInvoiceItems() async {
    await InvoiceItemApi.fetchAll();
  }

  _reloadTaxTypes() async {
    await TaxTypeApi.fetchAll();
  }

  _submitFormData() {
    SmartInvoiceItem smartInvoiceItem = SmartInvoiceItem();
    InvoiceFormItem invoiceFormItem = InvoiceFormItem(
      item: invoiceItem,
      description: descriptionController.text,
      amount: amountController.text,
      taxType: taxType,
      totalAmount: totalAmountController.text,
    );

    invoiceFormItemList.add(invoiceFormItem);
    InvoiceFormItemListItemList.add(InvoiceFormItemListItem(item: invoiceFormItem));

    // (widget.invoice == null)
    //     ? InvoiceApi.post(
    //   smartInvoiceItem.createInvoiceToJson(),
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
    //   smartInvoiceItem.createInvoiceToJson(),
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
}
