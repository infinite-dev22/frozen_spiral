import 'package:flutter/material.dart';

import '../theme/color.dart';

class FormTitle extends StatelessWidget {
  const FormTitle({
    super.key,
    required this.name,
    this.onSave,
  });

  final String name;
  final Function()? onSave;

  @override
  Widget build(BuildContext context) {
    return _buildBody(name, context);
  }

  _buildBody(String name, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
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
          child: const Text(
            'Save',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
