import 'package:flutter/material.dart';

class RequisitionItemStatus extends StatelessWidget {
  const RequisitionItemStatus(
      {super.key,
      required this.name,
      required this.bgColor,
      required this.horizontalPadding,
      required this.verticalPadding});

  final String name;
  final Color bgColor;
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
        color: bgColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Text(name,
          style: const TextStyle(
            color: Colors.white,
          )),
    );
  }
}
