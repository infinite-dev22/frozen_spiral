import 'package:flutter/material.dart';
import 'package:smart_case/models/smart_model.dart';

class SearchItem<T extends SmartModel> extends StatelessWidget {
  const SearchItem({
    super.key,
    required this.value,
    required this.padding,
    required this.color,
    this.onTap,
  });

  final T value;
  final double padding;
  final Color color;
  final Function(T?)? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap!(value),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          color: color,
        ),
        child: Center(child: Text(value.getName())),
      ),
    );
  }
}
