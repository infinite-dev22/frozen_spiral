import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(
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

  final file;
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
          image: (isNetwork)
              ? DecorationImage(
                  image: NetworkImage(file),
                  fit: imageFit,
                )
              : (isFile)
                  ? DecorationImage(
                      image: FileImage(file),
                      fit: imageFit,
                    )
                  : DecorationImage(
                      image: AssetImage(file),
                      fit: imageFit,
                    ),
        ),
      ),
    );
  }
}
