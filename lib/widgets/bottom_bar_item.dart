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
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double fontSize = 16;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            alignment: Alignment.center,
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
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
