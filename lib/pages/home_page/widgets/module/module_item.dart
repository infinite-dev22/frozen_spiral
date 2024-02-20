import 'package:flutter/material.dart';
import 'package:smart_case/pages/home_page/widgets/module/module_item_icon.dart';
import 'package:smart_case/theme/color.dart';

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
    double fontSize = 16;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ModuleItemIcon(
                icon: icon,
                iconSize: screenHeight * .04,
                radius: 100,
                padding: screenHeight * .03,
                color: AppColors.secondary.withOpacity(.5),
              ),
              SizedBox(
                height: screenHeight * .03,
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: fontSize,
                    color: AppColors.darker,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModuleItem2 extends StatelessWidget {
  const ModuleItem2(
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
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
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
              ModuleItemIcon2(
                icon: icon,
                iconSize: screenHeight * .04,
                radius: 100,
                padding: screenHeight * .03,
                color: AppColors.inActiveColor.withOpacity(.5),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: fontSize,
                    color: AppColors.inActiveColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.6),
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(20))),
              child: const Text(
                "Coming soon...",
                style: TextStyle(color: AppColors.white),
              ),
            ))
      ],
    );
  }
}
