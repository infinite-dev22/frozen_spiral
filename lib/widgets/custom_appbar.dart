import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_dropdown_filter.dart';
import 'custom_images/custom_elevated_image.dart';
import 'custom_images/custom_image.dart';
import 'custom_textbox.dart';

class AppBarContent extends StatelessWidget {
  AppBarContent({super.key, this.searchable = false, this.filterable = false, this.search = ''});

  final bool searchable;
  final bool filterable;
  final String search;

  final List<String> filters = [
    "Name",
    "Type",
    "Location",
    "Date Added",
  ];

  @override
  Widget build(BuildContext context) {
    return _buildAppBar();
  }

  _buildAppBar() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: searchable
                  ? CustomTextBox(
                      hint: "Search $search",
                      prefix: const Icon(Icons.search, color: Colors.grey),
                      onChanged: (value) {
                        if (kDebugMode) {
                          print(value);
                        }
                      },
                      autoFocus: false,
                    )
                  : const CustomImage(
                      "assets/images/title_bar.png",
                      width: 35,
                      height: 35,
                      trBackground: true,
                      isNetwork: false,imageFit: BoxFit.contain,
                      radius: 0,
                    ),
            ),
            const SizedBox(
              width: 20,
            ),
            filterable
                ? CustomDropdownFilter(
                    menuItems: filters,
                    bgColor: Colors.white,
                  )
                : CustomElevatedImage(
                    "assets/images/user_profile.jpg",
                    width: 35,
                    height: 35,
                    isNetwork: false,
                    radius: 10,
                    onTap: () {
                      if (kDebugMode) {
                        print('profile image tap');
                      }
                    },
                  ),
          ],
        ),
      ],
    );
  }
}
