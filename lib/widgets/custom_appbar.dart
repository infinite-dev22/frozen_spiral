import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

import 'custom_dropdown_filter.dart';
import 'custom_images/custom_elevated_image.dart';
import 'custom_images/custom_image.dart';
import 'custom_spacer.dart';
import 'custom_textbox.dart';

class AppBarContent extends StatelessWidget {
  AppBarContent(
      {super.key,
      this.searchable = false,
      this.filterable = false,
      this.search = '',
      this.signOut});

  final bool searchable;
  final bool filterable;
  final String search;
  final Function()? signOut;

  final List<String> filters = [
    "Name",
    "Type",
    "Location",
    "Date Added",
  ];

  final List<String> profileActions = [
    "Profile",
    "Sign out",
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
            if (!searchable)
              const CustomSpacer(
                width: 35,
                height: 35,
                radius: 10,
                bgColor: AppColors.primary,
              ),
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
                    graphic: Icons.filter_list_rounded,
                  )
                : CustomDropdownFilter(
                    menuItems: profileActions,
                    bgColor: Colors.white,
                    onChanged: (value) =>
                        _buildOnProfileDropdownValueChanged(value, context),
                    isImage: true,
                    graphic: "assets/images/user_profile.jpg",
                  ),
          ],
        ),
      ],
    );
  }

  _buildProfileDropDown(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 8),
      icon: const CustomElevatedImage(
        "assets/images/user_profile.jpg",
        width: 35,
        height: 35,
        isNetwork: false,
        radius: 10,
      ),
      itemBuilder: (context) {
        return [
          const PopupMenuItem<String>(
            child: Text(
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
      onSelected: (value) {},
    );
  }

  _buildOnProfileDropdownValueChanged(String? value, BuildContext context) {
    if (value == 'Profile') {
      return Navigator.pushNamed(context, '/profile');
    }
    if (value == 'Sign out') {
      if (kDebugMode) {
        print('User clicked sign out');
      }
    }
  }
}
