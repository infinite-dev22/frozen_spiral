import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/invoice/invoice_form_item.dart';
import 'package:smart_case/database/invoice/invoice_item_model.dart';
import 'package:smart_case/database/tax/tax_type_model.dart';
import 'package:smart_case/pages/invoice_page/bloc/forms/invoice/invoice_form_bloc.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_form_item_list_item.dart';
import 'package:smart_case/widgets/custom_dropdowns.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/form_title.dart';

class InvoiceItemsFormLayout extends StatefulWidget {
  final SmartInvoiceItem? smartInvoiceItem;
  final BuildContext grandParentContext;

  const InvoiceItemsFormLayout(
      {super.key, this.smartInvoiceItem, required this.grandParentContext});

  @override
  State<InvoiceItemsFormLayout> createState() => _InvoiceItemsFormLayoutState();
}

class _InvoiceItemsFormLayoutState extends State<InvoiceItemsFormLayout> {
  SmartInvoiceItem? invoiceItem;
  SmartTaxType? taxType;
  double taxableAmount = 0;

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

  _onTapSearchedItem(SmartInvoiceItem value) {
    setState(() {
      invoiceItem = value;
    });
  }

  _onTapSearchedTaxType(SmartTaxType value) {
    setState(() {
      taxType = value;
      if (!value.code!.toUpperCase().contains('NIL')) {
        totalAmountController.text = thousandFormatter
            .format(double.parse(
                    totalAmountController.text.replaceAll(",", "").toString()) +
                (double.parse(totalAmountController.text
                        .replaceAll(",", "")
                        .toString()) *
                    (double.parse(value.rate!) / 100)))
            .toString();
      }
      taxableAmount = double.parse(
              totalAmountController.text.replaceAll(",", "").toString()) *
          (double.parse(value.rate!) / 100);
    });
  }

  _submitFormData() {
    InvoiceFormItem invoiceFormItem = InvoiceFormItem(
      item: invoiceItem,
      description: descriptionController.text,
      amount:
          double.parse(amountController.text.replaceAll(",", "").toString()),
      taxType: taxType,
      totalAmount: double.parse(
          totalAmountController.text.replaceAll(",", "").toString()),
      taxableAmount: taxableAmount,
    );

    invoiceFormItemList.add(invoiceFormItem);
    invoiceFormItemListItemList
        .add(InvoiceFormItemListItem(item: invoiceFormItem));

    widget.grandParentContext
        .read<InvoiceFormBloc>()
        .add(RefreshInvoiceForm(invoiceFormItemListItemList));

    Navigator.pop(context);
  }

  @override
  void dispose() {
    amountController.dispose();
    totalAmountController.dispose();
    descriptionController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
