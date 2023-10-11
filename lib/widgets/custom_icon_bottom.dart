import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    this.icon = Icons.mode_edit_rounded,
    this.title = 'Edit',
    this.onTap,
  });

  final IconData? icon;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: AppColors.primary,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
            ),
          )
        ],
      ),
    );
  }
}
