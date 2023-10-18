import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool isEmail;
  final BorderSide borderSide;
  final Color fillColor;
  final TextStyle? style;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.isEmail = false,
    this.borderSide = BorderSide.none,
    this.fillColor = AppColors.textBoxColor,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        validator: (val) =>
            val!.isEmpty ? 'Required field, Please fill in.' : null,
        controller: controller,
        obscureText: obscureText,
        style: style,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: borderSide,
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: fillColor,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.inActiveColor,
            fontSize: 16,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }
}

class AuthPasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final BorderSide borderSide;
  final Color fillColor;
  final Color iconColor;
  final TextStyle? style;

  const AuthPasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.borderSide = BorderSide.none,
    this.fillColor = AppColors.textBoxColor,
    this.iconColor = AppColors.darker,
    this.style,
  });

  @override
  State<AuthPasswordTextField> createState() => _AuthPasswordTextField();
}

class _AuthPasswordTextField extends State<AuthPasswordTextField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        validator: (val) =>
            val!.isEmpty ? 'Required field, Please fill in.' : null,
        controller: widget.controller,
        obscureText: obscure,
        style: widget.style,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscure = !obscure;
                });
              },
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility_rounded,
                color: widget.iconColor,
              )),
          border: OutlineInputBorder(
            borderSide: widget.borderSide,
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: widget.fillColor,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: AppColors.inActiveColor,
            fontSize: 16,
          ),
        ),
        keyboardType: TextInputType.visiblePassword,
      ),
    );
  }
}
