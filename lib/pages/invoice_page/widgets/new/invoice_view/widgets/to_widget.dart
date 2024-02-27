import 'package:flutter/material.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/theme/color.dart';

class ToWidget extends StatelessWidget {
  final SmartInvoice invoice;

  const ToWidget({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        color: AppColors.white,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Billing Address",
              style: TextStyle(
                  color: AppColors.inActiveColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            if ((invoice.client != null && invoice.client!.address != null))
              Text(
                invoice.client == null ||
                        (invoice.client != null &&
                            invoice.client!.address == null)
                    ? "N/A"
                    : invoice.client!.address!,
                style: TextStyle(
                    color: AppColors.darker, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 5),
            if (invoice.client != null && invoice.client!.email != null)
              Text(
                invoice.client == null ||
                        (invoice.client != null &&
                            invoice.client!.email == null)
                    ? "N/A"
                    : invoice.client!.email!,
                style: TextStyle(
                    color: AppColors.inActiveColor,
                    fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 5),
            if (invoice.client != null && invoice.client!.telephone != null)
              Text(
                invoice.client == null ||
                        (invoice.client != null &&
                            invoice.client!.telephone == null)
                    ? "N/A"
                    : invoice.client!.telephone!,
                style: TextStyle(
                    color: AppColors.inActiveColor,
                    fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
