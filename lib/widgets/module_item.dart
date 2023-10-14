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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
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
              iconSize: screenHeight * .083,
              radius: 100,
              padding: screenHeight * .03,
              color: Colors.black12,
            ),
            SizedBox(
              height: screenHeight * .031,
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: screenWidth * .04,
                color: AppColors.darker,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
