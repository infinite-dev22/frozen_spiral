import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

import 'custom_dropdowns.dart';
import 'custom_images/custom_image.dart';
import 'custom_spacer.dart';
import 'custom_textbox.dart';

class AppBarContent extends StatelessWidget {
  AppBarContent(
      {super.key,
      this.searchable = false,
      this.filterable = false,
      this.search = '',
      this.signOut,
      this.isNetwork = false});

  final bool searchable;
  final bool filterable;
  final bool isNetwork;
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
                width: 50,
                height: 40,
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
                    icon: Icons.filter_list_rounded,onChanged: (value) {},
                  )
                : CustomDropdownAction(
                    menuItems: profileActions,
                    bgColor: Colors.white,
                    onChanged: (value) =>
                        _buildOnProfileDropdownValueChanged(value, context),
                    image: "assets/images/user_profile.jpg",
                  ),
          ],
        ),
      ],
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
