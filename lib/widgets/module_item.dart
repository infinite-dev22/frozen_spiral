import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/module_item_icon.dart';

class ModuleItem extends StatelessWidget {
  const ModuleItem(
      {super.key,
      required this.name,
      required this.color,
      required this.padding,
      required this.icon,
      this.onTap});

  final String name;
  final Color color;
  final double padding;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    double fontSize = screenWidth * .04;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        height: MediaQuery.of(context).size.height / 4.2,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
          color: color,
        ),
        child: Column(
          children: [
            ModuleItemIcon(
              icon: icon,
              iconSize: screenHeight * .04,
              radius: 100,
              padding: screenHeight * .03,
              color: AppColors.secondary.withOpacity(.5),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: fontSize,
                color: AppColors.darker,fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
    );
  }
}
