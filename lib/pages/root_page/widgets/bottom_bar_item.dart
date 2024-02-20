import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(
    this.icon,
    this.name, {
    super.key,
    this.onTap,
    this.badge,
    this.color = AppColors.inActiveColor,
    this.activeColor = AppColors.primary,
    this.isActive = false,
    this.showBadge = false,
    this.isNotified = false,
  });

  final IconData icon;
  final String name;
  final Text? badge;
  final Color color;
  final Color activeColor;
  final bool isNotified;
  final bool isActive;
  final bool showBadge;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    double fontSize = 14;
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
            child: (showBadge)
                ? Badge(
                    label: badge,
                    child: Icon(
                      icon,
                      size: 25,
                      color: isActive ? activeColor : color,
                    ),
                  )
                : Icon(
                    icon,
                    size: 25,
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
