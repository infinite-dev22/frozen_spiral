import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:smart_case/theme/color.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({
    super.key,
    this.hint = "",
    this.prefix,
    this.controller,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.autoFocus = false,
  });

  final String hint;
  final Widget? prefix;
  final bool readOnly;
  final bool autoFocus;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return _buildTextField();
  }

  _buildTextField() {
    return Container(
      alignment: Alignment.center,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              readOnly: readOnly,
              controller: controller,
              onChanged: onChanged,
              autofocus: autoFocus,
              maxLines: 1,
              maxLength: 33,
              decoration: InputDecoration(
                counterText: "",
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
}

class CustomTextArea extends StatelessWidget {
  const CustomTextArea(
      {super.key,
      this.hint,
      this.value,
      this.readOnly = false,
      this.autoFocus = false,
      this.controller,
      this.onChanged,
      this.minLines = 5,
      this.maxLines = 5,
      this.maxLength,
      this.onTap});

  final String? hint;
  final String? value;
  final bool readOnly;
  final bool autoFocus;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function()? onTap;
  final int minLines;
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      initialValue: value,
      autofocus: autoFocus,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      onTap: onTap,
      maxLength: maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (val) =>
          val!.isEmpty ? 'Required field, Please fill in.' : null,
      decoration: InputDecoration(
        counterText: "",
        filled: true,
        fillColor: AppColors.textBoxColor,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.inActiveColor),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class SmartCaseTextField extends StatelessWidget {
  const SmartCaseTextField(
      {super.key,
      required this.hint,
      required this.controller,
      this.minLines = 5,
      this.maxLines = 500,
      this.maxLength});

  final String hint;
  final TextEditingController controller;
  final int minLines;
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: TextFormField(
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) =>
                val!.isEmpty ? 'Required field, Please fill in.' : null,
            maxLength: maxLength,
            maxLines: maxLines,
            minLines: minLines,
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: AppColors.textBoxColor,
              hintText: hint,
              hintStyle:
                  const TextStyle(color: AppColors.inActiveColor, fontSize: 15),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class SmartCaseNumberField extends StatelessWidget {
  const SmartCaseNumberField({
    super.key,
    required this.hint,
    required this.controller,
    this.maxLength,
    this.onChanged,
  });

  final String hint;
  final TextEditingController controller;
  final int? maxLength;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: TextFormField(
            controller: controller,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (val) =>
                val!.isEmpty ? 'Required field, Please fill in.' : null,
            maxLength: maxLength,
            minLines: 1,
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: AppColors.textBoxColor,
              hintText: hint,
              hintStyle:
                  const TextStyle(color: AppColors.inActiveColor, fontSize: 15),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyInputFormatter()],
            onChanged: onChanged,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class SmartText extends StatelessWidget {
  const SmartText(
      {super.key,
      required this.value,
      required this.icon,
      required this.color});

  final IconData icon;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.textBoxColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
