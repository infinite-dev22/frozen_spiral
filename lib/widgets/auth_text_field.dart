import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class AuthTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final bool isEmail;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.isEmail = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: (val) =>
            val!.isEmpty ? 'Required field, Please fill in.' : null,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.primary),
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16)),
        keyboardType:
            isEmail ? TextInputType.emailAddress : TextInputType.text);
  }
}

class AuthPasswordTextField extends StatefulWidget {
  final controller;
  final String hintText;

  const AuthPasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<AuthPasswordTextField> createState() => _AuthPasswordTextField();
}

class _AuthPasswordTextField extends State<AuthPasswordTextField> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val) =>
          val!.isEmpty ? 'Required field, Please fill in.' : null,
      controller: widget.controller,
      obscureText: obscure,
      decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscure = !obscure;
                });
              },
              icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility_rounded)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16)),
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
