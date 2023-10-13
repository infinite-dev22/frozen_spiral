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
    required this.graphic,
    this.isImage = false,
    this.isNetwork = false,
  });

  final List<String> menuItems;
  final Function(String?)? onChanged;
  final Color bgColor;
  final graphic;
  final bool isImage;
  final bool isNetwork;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    print("Graphic runtime type: ${graphic.runtimeType}");
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: (graphic.runtimeType.toString() == "String")
            ? CustomElevatedImage(graphic,
                width: 40,
                height: 40,
                isNetwork: isNetwork,
                radius: 10,
              )
            : CustomIconHolder(
                width: 35,
                height: 35,
                radius: 10,
                isImage: isImage,
                bgColor: bgColor,
                graphic: graphic,
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
