import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import '../models/smart_model.dart';
import '../theme/color.dart';
import 'custom_icon_holder.dart';
import 'custom_images/custom_elevated_image.dart';

class CustomDropdownFilter extends StatefulWidget {
  const CustomDropdownFilter({
    super.key,
    required this.menuItems,
    this.onChanged,
    required this.bgColor,
    required this.icon,
    this.size,
    this.radius = 10,
  });

  final List<String> menuItems;
  final Function(String?)? onChanged;
  final Color bgColor;
  final IconData icon;
  final double? size;
  final double radius;

  @override
  State<CustomDropdownFilter> createState() => _CustomDropdownFilterState();
}

class _CustomDropdownFilterState extends State<CustomDropdownFilter> {
  bool checkValue = false;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: CustomIconHolder(
          width: 35,
          height: 35,
          radius: widget.radius,
          size: widget.size,
          bgColor: widget.bgColor,
          graphic: widget.icon,
        ),
        items: widget.menuItems
            .map((item) => DropdownMenuItem<String>(
                alignment: Alignment.centerLeft,
                value: item,
                child: Row(
                  children: [
                    Checkbox(
                      value: checkValue,
                      onChanged: (bool? value) {
                        setState(() {
                          checkValue = value!;
                        });
                      },
                    ),
                    Text(
                      item,
                      style: const TextStyle(
                        color: AppColors.darker,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )))
            .toList(),
        onChanged: widget.onChanged,
        dropdownStyleData: DropdownStyleData(
          width: 170,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          offset: const Offset(-60, -6),
        ),
      ),
    );
  }
}

class CustomDropdownAction extends StatelessWidget {
  const CustomDropdownAction({
    super.key,
    required this.menuItems,
    this.onChanged,
    required this.bgColor,
    required this.image,
    this.isNetwork = false,
  });

  final List<String> menuItems;
  final Function(String?)? onChanged;
  final Color bgColor;
  final dynamic image;
  final bool isNetwork;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: CustomElevatedImage(
          image,
          width: 40,
          height: 40,
          isNetwork: isNetwork,
          radius: 10,
        ),
        items: menuItems
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        dropdownStyleData: DropdownStyleData(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          offset: const Offset(-60, -6),
        ),
      ),
    );
  }
}

class SearchableDropDown<T extends SmartModel> extends StatelessWidget {
  const SearchableDropDown(
      {super.key,
      required this.hintText,
      required this.menuItems,
      this.onChanged,
      this.defaultValue,
      required this.controller});

  final String hintText;
  final List<T> menuItems;
  final T? defaultValue;
  final Function(dynamic)? onChanged;
  final SingleValueDropDownController controller;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10),
      child: DropDownTextField(
        controller: controller,
        enableSearch: true,
        dropdownColor: Colors.white,
        textFieldDecoration: InputDecoration(
          filled: true,
          fillColor: AppColors.textBoxColor,
          hintText: 'Select $hintText',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        searchDecoration: InputDecoration(hintText: "Search $hintText"),
        validator: (value) {
          if (value == null) {
            return "Required field";
          } else {
            return null;
          }
        },
        dropDownItemCount: 6,
        dropDownIconProperty: IconProperty(
          icon: Icons.keyboard_arrow_down_rounded,
          color: AppColors.darker,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        dropDownList: menuItems
            .map(
                (item) => DropDownValueModel(value: item, name: item.getName()))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class CustomGenericDropdown<T extends SmartModel> extends StatelessWidget {
  const CustomGenericDropdown(
      {super.key,
      required this.hintText,
      required this.menuItems,
      this.onChanged,
      this.defaultValue});

  final String hintText;
  final List<T> menuItems;
  final T? defaultValue;
  final Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: DropdownButtonFormField2<T>(
            alignment: Alignment.centerLeft,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            value: defaultValue,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              filled: true,
              fillColor: AppColors.textBoxColor,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            hint: Text(
              'Select $hintText',
              style:
                  const TextStyle(color: AppColors.inActiveColor, fontSize: 15),
            ),
            items: menuItems
                .map((item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        item.getName(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Please select a $hintText';
              }
              return null;
            },
            onChanged: onChanged,
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.darker,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class GenderDropdown extends StatelessWidget {
  const GenderDropdown({
    super.key,
    this.onChanged,
  });

  final Function(int?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: DropdownButtonFormField2<int>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              filled: true,
              fillColor: AppColors.textBoxColor,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            hint: const Text(
              'Select gender',
              style: TextStyle(color: AppColors.inActiveColor, fontSize: 15),
            ),
            items: const [
              DropdownMenuItem<int>(
                value: 1,
                child: Text(
                  'Male',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              DropdownMenuItem<int>(
                value: 0,
                child: Text(
                  'Female',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
            validator: (value) {
              if (value == null) {
                return 'Please select a gender';
              }
              return null;
            },
            onChanged: onChanged,
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
