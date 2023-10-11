import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    this.icon = Icons.mode_edit_rounded,
    this.title = 'Edit',
    this.onPressed,
  });

  final IconData? icon;
  final String title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return TextButton(
      onPressed: onPressed,
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
