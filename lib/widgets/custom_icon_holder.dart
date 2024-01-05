import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/custom_image.dart';

class CustomIconHolder extends StatelessWidget {
  const CustomIconHolder(
      {super.key,
      required this.width,
      required this.height,
      this.bgColor,
      required this.radius,
      required this.graphic,
      this.isImage = false,
      this.size,
      this.isProfile = false});

  final double width;
  final double height;
  final Color? bgColor;
  final double radius;
  final double? size;
  final bool isImage;
  final bool isProfile;
  final dynamic graphic;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return (isProfile)
        ? Icon(
            graphic,
            color: isProfile ? AppColors.inActiveColor : AppColors.primary,
            size: size,
          )
        : Container(
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
            child: (isImage)
                ? CustomImage(
                    graphic,
                    width: 35,
                    height: 35,
                    isNetwork: false,
                    radius: 10,
                  )
                : Icon(
                    graphic,
                    color: AppColors.primary,
                    size: size,
                  ),
          );
  }
}
