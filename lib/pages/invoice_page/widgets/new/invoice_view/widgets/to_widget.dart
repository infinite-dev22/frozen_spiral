import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class ToWidget extends StatelessWidget {
  const ToWidget({super.key});

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
              "To",
              style: TextStyle(
                  color: AppColors.inActiveColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "banana Inc.",
              style: TextStyle(
                  color: AppColors.darker, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "134, High street, New Jersey, NYC, 1123233",
              style: TextStyle(
                  color: AppColors.darker, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "finance@banana.com",
              style: TextStyle(
                  color: AppColors.inActiveColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              "+1(233)3423-2323",
              style: TextStyle(
                  color: AppColors.inActiveColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
