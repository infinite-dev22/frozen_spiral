import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

class InvoiceTermsWidget extends StatelessWidget {
  final TextEditingController? controller;

  const InvoiceTermsWidget({
    super.key,
    this.controller,
  });

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
          CustomTextArea(
            hint: "Invoice Terms",
            controller: controller,
          ),
        ],
      ),
    );
  }
}
