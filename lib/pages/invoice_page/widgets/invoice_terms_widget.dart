import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class InvoiceTermsWidget extends StatelessWidget {
  const InvoiceTermsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Invoice Terms", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            "1. Accounts carry interest at 6% effective one month form the date of receipt hereof R:6.",
            softWrap: true,
          ),
          Text(
            "2. Under VAT Statute 1996, 18% is payable on all fees.",
            softWrap: true,
          ),
          Text(
            "3. Accounts carry interest at 6% effective one month from the date date of receipt hereof R:6.",
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
