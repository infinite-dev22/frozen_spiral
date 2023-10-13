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
    return _buildBody();
  }

  _buildBody() {
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
              iconSize: 40,
              radius: 50,
              padding: 20,
              color: Colors.black12,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.darker,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
