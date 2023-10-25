import 'package:flutter/material.dart';

import '../theme/color.dart';

class FormTitle extends StatelessWidget {
  const FormTitle({
    super.key,
    required this.name,
    this.onSave,
    this.isElevated = false,
  });

  final String name;
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
        color: AppColors.appBgColor,
        boxShadow: (isElevated)
            ? [
                BoxShadow(
                  color: AppColors.shadowColor.withOpacity(.1),
                  spreadRadius: 1,
                  blurRadius: 1.0,
                  offset: const Offset(0.0, 1), // changes position of shadow
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
            child: const Text(
              'Add',
              style: TextStyle(
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
