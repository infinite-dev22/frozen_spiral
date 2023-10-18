import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(
    this.icon,
    this.name, {
    super.key,
    this.onTap,
    this.color = AppColors.inActiveColor,
    this.activeColor = AppColors.primary,
    this.isActive = false,
    this.isNotified = false,
  });

  final IconData icon;
  final String name;
  final Color color;
  final Color activeColor;
  final bool isNotified;
  final bool isActive;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Icon(
                icon,
                size: 30,
                color: isActive ? activeColor : color,
              ),
            ),
            Text(
              name,
              style: TextStyle(
                color: isActive ? activeColor : color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
