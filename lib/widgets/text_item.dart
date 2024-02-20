import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../theme/color.dart';

class TextItem extends StatelessWidget {
  const TextItem({super.key, required this.title, required this.data});

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.inActiveColor,
          ),
        ),
        Text(
          data,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          softWrap: true,
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

class TextItemMacquee extends StatelessWidget {
  const TextItemMacquee({super.key, required this.title, required this.data});

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.inActiveColor,
          ),
        ),
        SizedBox(
          height: 50,
          child: Marquee(
            text: data,
            velocity: 50.0,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            blankSpace: 238,
            pauseAfterRound: const Duration(seconds: 3),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

class FreeTextItem extends StatelessWidget {
  const FreeTextItem({super.key, required this.title, required this.data});

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.inActiveColor,
          ),
        ),
        Text(
          data,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          softWrap: true,
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}

class SpacedTextItem extends StatelessWidget {
  final String title;
  final String data;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;

  const SpacedTextItem(
      {super.key,
      required this.title,
      required this.data,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.fontStyle});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
          ),
        ),
        Text(
          data,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
          ),
        ),
      ],
    );
  }
}
