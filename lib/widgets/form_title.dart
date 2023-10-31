import 'package:flutter/material.dart';

import '../theme/color.dart';

class FormTitle extends StatelessWidget {
  const FormTitle({
    super.key,
    required this.name,
    this.onSave,
    this.isElevated = false,
    this.addButtonText = 'Add',
  });

  final String name;
  final String addButtonText;
  final Function()? onSave;
  final bool isElevated;

  @override
  Widget build(BuildContext context) {
    return _buildBody(name, context);
  }

  _buildBody(String name, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: isElevated ? Colors.white : AppColors.appBgColor,
        boxShadow: (isElevated)
            ? [
                BoxShadow(
                  color: AppColors.shadowColor.withOpacity(.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0.0, 2), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: Row(
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
            child: Text(
              addButtonText,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
