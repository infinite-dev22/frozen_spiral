import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({
    Key? key,
    this.hint = "",
    this.prefix,
    this.controller,
    this.readOnly = false,
    required this.onChanged,
    this.onTap,
    this.autoFocus = false,
  }) : super(key: key);

  final String hint;
  final Widget? prefix;
  final bool readOnly;
  final bool autoFocus;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return (readOnly) ? _buildTextFieldButton() : _buildTextField();
  }

  _buildTextField() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 3),
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.appBgColor,
        border: Border.all(color: AppColors.textBoxColor),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(.05),
            spreadRadius: .5,
            blurRadius: .5,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              readOnly: readOnly,
              controller: controller,
              onChanged: onChanged,
              autofocus: autoFocus,
              decoration: InputDecoration(
                prefixIcon: prefix,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  _buildTextFieldButton() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 3),
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.appBgColor,
          border: Border.all(color: AppColors.textBoxColor),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(.05),
              spreadRadius: .5,
              blurRadius: .5,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          readOnly: readOnly,
          controller: controller,
          onTap: onTap,
          decoration: InputDecoration(
            prefixIcon: prefix,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
        ));
  }
}

class CustomTextArea extends StatelessWidget {
  const CustomTextArea(
      {super.key,
      this.hint = '',
      this.readOnly = false,
      this.autoFocus = false,
      this.controller,
      this.onChanged,
      this.minLines = 5});

  final String hint;
  final bool readOnly;
  final bool autoFocus;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final int minLines;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          autofocus: autoFocus,
          onChanged: onChanged,
          minLines: minLines,
          maxLines: 500,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.textBoxColor,
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.inActiveColor),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
