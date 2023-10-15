import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'custom_icon_holder.dart';
import 'custom_images/custom_elevated_image.dart';

class CustomDropdownFilter extends StatelessWidget {
  const CustomDropdownFilter({
    super.key,
    required this.menuItems,
    this.onChanged,
    required this.bgColor,
    required this.icon,
  });

  final List<String> menuItems;
  final Function(String?)? onChanged;
  final Color bgColor;
  final IconData icon;

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
        customButton: CustomElevatedImage(image,
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
