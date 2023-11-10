import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class CustomElevatedImage extends StatelessWidget {
  const CustomElevatedImage(
    this.file, {
    super.key,
    this.width = 100,
    this.height = 100,
    this.bgColor,
    this.borderWidth = 0,
    this.borderColor,
    this.trBackground = false,
    this.isNetwork = true,
    this.radius = 50,
    this.imageFit = BoxFit.cover,
    this.onClose,
    this.onTap,
    this.isFile = false,
  });

  final dynamic file;
  final double width;
  final double height;
  final double borderWidth;
  final Color? borderColor;
  final Color? bgColor;
  final bool trBackground;
  final bool isNetwork;
  final bool isFile;
  final double radius;
  final BoxFit imageFit;
  final Function()? onClose;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }

  _buildImage() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          image: (isNetwork)
              ? DecorationImage(
                  image: ResizeImage(
                    NetworkImage(file),
                    width: width.toInt(),
                    height: height.toInt(),
                  ),
                  fit: imageFit,
                )
              : (isFile)
                  ? DecorationImage(
                      image: ResizeImage(
                        FileImage(file),
                        width: width.toInt(),
                        height: height.toInt(),
                      ),
                      fit: imageFit,
                    )
                  : DecorationImage(
                      image: ResizeImage(
                        AssetImage(file),
                        width: width.toInt() * 3,
                        height: height.toInt() * 4,
                      ),
                      fit: imageFit,
                    ),
        ),
      ),
    );
  }
}
