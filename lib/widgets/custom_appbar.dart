import 'package:flutter/material.dart';
import 'package:smart_case/services/apis/auth_apis.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:toast/toast.dart';

import 'custom_dropdowns.dart';
import 'custom_images/custom_image.dart';
import 'custom_spacer.dart';
import 'custom_textbox.dart';

class AppBarContent extends StatelessWidget {
  AppBarContent(
      {super.key,
      this.searchable = false,
      this.canNavigate = false,
      this.filterable = false,
      this.search = '',
      this.signOut,
      this.isNetwork = false,
      this.onChanged, this.filterController});

  final bool searchable;
  final bool canNavigate;
  final bool filterable;
  final bool isNetwork;
  final String search;
  final Function()? signOut;
  final Function(String)? onChanged;
  final TextEditingController? filterController;

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
    final ToastContext toast = ToastContext();
    toast.init(context);

    return _buildAppBar(context);
  }

  _buildAppBar(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            (!searchable && !canNavigate) ?
              const CustomSpacer(
                width: 50,
                height: 40,
                radius: 10,
                bgColor: Colors.transparent,
              ) : const SizedBox(),
            Expanded(
              child: searchable
                  ? CustomTextBox(
                      hint: "Search $search",
                      prefix: const Icon(Icons.search, color: Colors.grey),
                      onChanged: onChanged,
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
                    icon: Icons.filter_list_rounded,
                    onChanged: (value) {
                      filterController!.text = value!;
                    },
                  )
                : isNetwork
                    ? CustomDropdownAction(
                        menuItems: profileActions,
                        bgColor: Colors.white,
                        isNetwork: isNetwork,
                        onChanged: (value) =>
                            _buildOnProfileDropdownValueChanged(value, context),
                        image: currentUser.avatar,
                      )
                    : CustomDropdownFilter(
                        menuItems: profileActions,
                        bgColor: Colors.white,
                        icon: Icons.account_circle,
                        radius: 50,
                        size: 35,
                        onChanged: (value) =>
                            _buildOnProfileDropdownValueChanged(value, context),
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
      AuthApis.signOutUser(onSuccess: (value) {
        Navigator.popUntil(context, (route) => false);
        Navigator.pushNamed(context, '/');
      }, onError: (Object object, StackTrace stackTrace) {
        Toast.show("An error occurred",
            duration: Toast.lengthLong, gravity: Toast.bottom);
      });
    }
  }
}
