import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class WideButton extends StatelessWidget {
  const WideButton({super.key, this.onPressed, required this.name});

  final Function()? onPressed;
  final String name;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: FilledButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => AppColors.primary),
          ),
          onPressed: onPressed,
          child: Text(
            name,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
