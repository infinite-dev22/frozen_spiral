import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'custom_icon_holder.dart';

class CustomDropdownFilter extends StatelessWidget {
  const CustomDropdownFilter(
      {super.key,
      required this.menuItems,
      this.onChanged,
      required this.bgColor});

  final List<String> menuItems;
  final Function(dynamic)? onChanged;
  final Color bgColor;

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
          radius: 10,
          bgColor: bgColor,
          icon: Icons.filter_list,
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
        onChanged: (value){},
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
