import 'package:flutter/material.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/theme/color.dart';

class TermsWidget extends StatelessWidget {
  final SmartInvoice invoice;

  const TermsWidget({super.key, required this.invoice});

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
              "Terms",
              style: TextStyle(
                  color: AppColors.inActiveColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              invoice.paymentTerms!
                  .replaceAll("<ol>", "")
                  .replaceAll("</ol>", "")
                  .replaceAll("<li>", "")
                  .replaceAll("</li>", ""),
              style: TextStyle(
                  color: AppColors.darker, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
