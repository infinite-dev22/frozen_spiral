import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class ModuleItemIcon extends StatelessWidget {
  const ModuleItemIcon(
      {super.key,
      required this.icon,
      required this.iconSize,
      required this.radius,
      required this.color,
      required this.padding});

  final IconData icon;
  final double iconSize;
  final double radius;
  final double padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
      child: Icon(
        icon,
        size: iconSize,
        color: AppColors.primary,
      ),
    );
  }
}
