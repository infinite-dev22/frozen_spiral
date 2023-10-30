import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../models/smart_model.dart';
import '../theme/color.dart';
import 'custom_icon_holder.dart';
import 'custom_images/custom_elevated_image.dart';

class CustomDropdownFilter extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: CustomIconHolder(
          width: 35,
          height: 35,
          radius: radius,
          size: size,
          bgColor: bgColor,
          graphic: icon,
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
  final image;
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
    // DropDownTextField(
    //       // initialValue: "name4",
    //       controller: controller,
    //       clearOption: true,
    //       // enableSearch: true,
    //       // dropdownColor: Colors.green,
    //       searchDecoration: InputDecoration(
    //           hintText: "Select $hintText"),
    //       validator: (value) {
    //         if (value == null) {
    //           return "Required field";
    //         } else {
    //           return null;
    //         }
    //       },
    //       dropDownItemCount: menuItems.length,
    //
    //       dropDownList: menuItems.map((item) => DropDownValueModel(name: item.getName(), value: item.getId())).toList(),
    //       onChanged: (value) => onChanged!(value),
    //     )

    return SearchableDropdown<T>(
      backgroundDecoration: (child) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
      trailingIcon: const Icon(
        Icons.arrow_drop_down,
        size: 25,
        color: Colors.black45,
      ),
      hintText: Text('Select $hintText'),
      margin: const EdgeInsets.all(15),
      items: menuItems
          .map((item) => SearchableDropdownMenuItem(
              value: item, label: item.getName(), child: Text(item.getName())))
          .toList(),
      onChanged: onChanged,
      value: defaultValue,
      searchHintText: 'Search $hintText',
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
