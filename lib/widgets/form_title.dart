import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/util/smart_case_init.dart';

import '../theme/color.dart';

class FormTitle extends StatelessWidget {
  const FormTitle({
    super.key,
    required this.name,
    this.onSave,
    this.onCancel,
    this.isElevated = false,
    this.addButtonText = 'Add',
  });

  final String name;
  final String addButtonText;
  final Function()? onSave;
  final Function()? onCancel;
  final bool isElevated;

  @override
  Widget build(BuildContext context) {
    return _buildBody(name, context);
  }

  _buildBody(String name, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: isElevated ? Colors.white : AppColors.appBgColor,
        boxShadow: (isElevated)
            ? [
                BoxShadow(
                  color: AppColors.shadowColor.withOpacity(.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0.0, 2), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onCancel ?? () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.red,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          TextButton(
            onPressed: onSave,
            child: Text(
              addButtonText,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalendarViewTitle extends StatelessWidget {
  const CalendarViewTitle({
    super.key,
    required this.title,
    this.onPressed,
    this.isElevated = false,
  });

  final String title;
  final Function()? onPressed;
  final bool isElevated;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: (isElevated)
            ? [
                BoxShadow(
                  color: AppColors.shadowColor.withOpacity(.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0.0, 2), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.red,
            ),
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width - 96,
          //   height: 50,
          //   child: Marquee(
          //     text: "$title | ",
          //     velocity: 50.0,
          //     style: const TextStyle(fontSize: 18),
          //     blankSpace: 0,
          //     pauseAfterRound: const Duration(seconds: 3),
          //   ),
          // ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 96,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.edit_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceViewTitle extends StatelessWidget {
  final SmartInvoice invoice;

  const InvoiceViewTitle({
    super.key,
    this.onEdit,
    this.onPrint,
    this.onSave,
    this.onCancel,
    this.isElevated = false,
    required this.invoice,
  });

  final Function()? onEdit;
  final Function()? onPrint;
  final Function()? onSave;
  final Function()? onCancel;
  final bool isElevated;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: isElevated ? Colors.white : AppColors.appBgColor,
        boxShadow: (isElevated)
            ? [
                BoxShadow(
                  color: AppColors.shadowColor.withOpacity(.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0.0, 2), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onCancel ?? () => Navigator.pop(context),
            icon: const Icon(
              FontAwesome.xmark_solid,
              color: AppColors.red,
            ),
          ),
          Text(
            "Invoice Preview",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Row(
            children: [
              if (invoice.doneBy == currentUser.id ||
                  invoice.invoiceStatus2!.code
                      .toLowerCase()
                      .contains("submitted".toLowerCase()) ||
                  invoice.invoiceStatus2!.code
                      .toLowerCase()
                      .contains("returned".toLowerCase()) ||
                  invoice.invoiceStatus2!.code
                      .toLowerCase()
                      .contains("edited".toLowerCase()))
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(FontAwesome.pen_to_square),
                ),
              const SizedBox(height: 5),
              IconButton(
                onPressed: onPrint,
                icon: Icon(FontAwesome.print_solid),
              ),
              const SizedBox(height: 5),
              if (invoice.doneBy == currentUser.id ||
                  invoice.invoiceStatus2!.code
                      .toLowerCase()
                      .contains("edited".toLowerCase()) ||
                  !invoice.invoiceStatus2!.code
                      .toLowerCase()
                      .contains("rejected".toLowerCase()) ||
                  !invoice.invoiceStatus2!.code
                      .toLowerCase()
                      .contains("returned".toLowerCase()) ||
                  !invoice.invoiceStatus2!.code
                      .toLowerCase()
                      .contains("approved".toLowerCase()))
                IconButton(
                  onPressed: onSave,
                  icon: Icon(FontAwesome.floppy_disk),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
