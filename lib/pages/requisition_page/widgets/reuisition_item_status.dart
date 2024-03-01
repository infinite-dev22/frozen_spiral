import 'package:flutter/material.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_case/theme/color.dart';

class RequisitionItemStatus extends StatelessWidget {
  const RequisitionItemStatus(
      {super.key,
        required this.name,
        required this.color,
        required this.horizontalPadding,
        required this.verticalPadding});

  final String name;
  final Color color;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.2),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: SearchHighlightText(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
        ),
        highlightStyle: TextStyle(
          // fontSize: 14,
          fontWeight: FontWeight.bold,
          color: color,
          backgroundColor: AppColors.searchText,
        ),
      ),
    );
  }
}
