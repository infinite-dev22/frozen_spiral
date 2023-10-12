import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_dropdown_filter.dart';
import 'custom_images/custom_elevated_image.dart';
import 'custom_images/custom_image.dart';
import 'custom_textbox.dart';

class AppBarContent extends StatelessWidget {
  AppBarContent(
      {super.key,
      this.searchable = false,
      this.filterable = false,
      this.search = '',
      this.signOut,
      this.profile});

  final bool searchable;
  final bool filterable;
  final String search;
  final Function()? signOut;
  final Function()? profile;

  final List<String> filters = [
    "Name",
    "Type",
    "Location",
    "Date Added",
  ];

  @override
  Widget build(BuildContext context) {
    return _buildAppBar(context);
  }

  _buildAppBar(BuildContext context) {
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
                      isNetwork: false,
                      imageFit: BoxFit.contain,
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
                : _buildProfileDropDown(context),
          ],
        ),
      ],
    );
  }

  _buildProfileDropDown(BuildContext context) {
    return PopupMenuButton(offset: const Offset(0, 8),
      icon: const CustomElevatedImage(
        "assets/images/user_profile.jpg",
        width: 35,
        height: 35,
        isNetwork: false,
        radius: 10,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            onTap: profile,
            child: const Text(
              'Profile',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          PopupMenuItem<String>(
            onTap: signOut,
            child: const Text(
              'Sign out',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ];
      },
      onSelected: (value) {
        if (value == 'Sign out') {
          if (kDebugMode) {
            print('User clicked sign out');
          }
        }
      },
    );
  }
}
