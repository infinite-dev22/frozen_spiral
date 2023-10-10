import 'package:flutter/material.dart';

import '../theme/color.dart';

class CustomIconHolder extends StatelessWidget {
  const CustomIconHolder(
      {super.key,
      required this.width,
      required this.height,
      this.bgColor,
      required this.radius, required this.icon});

  final double width;
  final double height;
  final Color? bgColor;
  final double radius;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: .1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Icon(icon),
    );
  }
}
