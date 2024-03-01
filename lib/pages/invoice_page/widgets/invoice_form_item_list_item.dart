import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/invoice/invoice_form_item.dart';
import 'package:smart_case/pages/invoice_page/bloc/forms/invoice/invoice_form_bloc.dart';
import 'package:smart_case/pages/invoice_page/forms/invoice_items_form.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/text_item.dart';

class InvoiceFormItemListItem extends StatefulWidget {
  final InvoiceFormItem item;
  final int? index;
  final BuildContext grandParentContext;

  const InvoiceFormItemListItem(
      {super.key,
      this.index,
      required this.item,
      required this.grandParentContext});

  @override
  State<InvoiceFormItemListItem> createState() =>
      _InvoiceFormItemListItemState();
}

class _InvoiceFormItemListItemState extends State<InvoiceFormItemListItem> {
  var numberFormat = NumberFormat("###,###,###,###,##0.00");

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Slidable(
              // Specify a key if the Slidable is dismissible.
              key: ValueKey(
                  "${widget.item.item}-${widget.item.amount!}-${widget.item.totalAmount!}-${widget.grandParentContext}"),
              // The end action pane is the one at the right or the bottom side.
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) =>
                        _showItemsDialog(widget.grandParentContext),
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.white,
                    icon: FontAwesome.pen_to_square,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      invoiceFormItemList.removeAt(widget.index!);
                      widget.grandParentContext
                          .read<InvoiceFormBloc>()
                          .add(RefreshInvoiceForm(invoiceFormItemListItemList));
                    },
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                    icon: FontAwesome.trash_can,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                ],
              ),

              // The child of the Slidable is what the user sees when the
              // component is not dragged.
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth * .5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextItem(
                              title: "Case Payment Type",
                              data: widget.item.item!.getName(),
                            ),
                            if (widget.item.description != null)
                              TextItem(
                                title: "Item Description",
                                data: widget.item.description!,
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextItem(
                                title: "Sub total",
                                data: "${numberFormat.format(widget.item.amount!)}",
                              ),
                              TextItem(
                                title: "Amount",
                                data:
                                    "${numberFormat.format(widget.item.totalAmount!)}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              indent: 0,
              endIndent: 0,
              height: 15,
            ),
          ],
        ),
      );
    });
  }

  _showItemsDialog(BuildContext cntxt) {
    return showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height * .8),
      context: context,
      builder: (context) => InvoiceItemsForm(parentContext: cntxt),
    );
  }
}
