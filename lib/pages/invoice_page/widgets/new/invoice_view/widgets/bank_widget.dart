import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class BankWidget extends StatelessWidget {
  const BankWidget({super.key});

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
              "Bank",
              style: TextStyle(
                  color: AppColors.inActiveColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Stanbic Bank",
              style: TextStyle(
                  color: AppColors.darker, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "Training & Co. Advocates",
              style: TextStyle(
                  color: AppColors.darker, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "UGX0034EDX",
              style: TextStyle(
                  color: AppColors.inActiveColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "01234567890",
              style: TextStyle(
                  color: AppColors.inActiveColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
