import 'dart:io';

import 'package:flutter/material.dart';

class PicSuccess extends StatelessWidget {
  const PicSuccess(
    this.image,this.imageUrl,
      {
    super.key,
    this.width = 100,
    this.height = 100,
    this.bgColor,
    this.radius = 50,
    this.imageFit = BoxFit.cover,
  });

  final File? image;
  final String imageUrl;
  final double width;
  final double height;
  final Color? bgColor;
  final double radius;
  final BoxFit imageFit;

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
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: imageFit,
        ),
      ),
    );
  }
}
