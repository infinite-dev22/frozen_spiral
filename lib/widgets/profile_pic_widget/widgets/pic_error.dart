import 'package:flutter/material.dart';

class PicError extends StatelessWidget {
  const PicError({
    super.key,
    this.width = 100,
    this.height = 100,
    this.radius = 50,
    this.bgColor,
  });

  final double width;
  final double height;
  final double radius;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }

  _buildImage() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: const Center(
        child: Icon(Icons.error_outline_rounded),
      ),
    );
  }
}
