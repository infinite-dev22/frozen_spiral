import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class InvoiceAddItemsWidget extends StatelessWidget {
  final Function()? onTap;

  const InvoiceAddItemsWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Add Items"),
              Icon(Icons.add_circle_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
