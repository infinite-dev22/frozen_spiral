import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_dropdowns.dart';
import 'package:smart_case/widgets/custom_image.dart';
import 'package:smart_case/widgets/custom_spacer.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

class AppBarContent extends StatelessWidget {
  AppBarContent(
      {super.key,
      this.searchable = false,
      this.canNavigate = false,
      this.filterable = false,
      this.readOnly = false,
      this.search = '',
      this.signOut,
      this.isNetwork = false,
      this.onChanged,
      this.filterController,
      this.searchController,
      this.filters});

  final bool searchable;
  final bool canNavigate;
  final bool filterable;
  final bool isNetwork;
  final bool readOnly;
  final String search;
  final Function()? signOut;
  final Function(String)? onChanged;
  final TextEditingController? filterController;
  final TextEditingController? searchController;
  final List<String>? filters;

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
            (!searchable && !canNavigate)
                ? const CustomSpacer(
                    width: 50,
                    height: 40,
                    radius: 10,
                    bgColor: Colors.transparent,
                  )
                : const SizedBox(),
            Expanded(
              child: searchable
                  ? CustomTextBox(
                      hint: "Search $search",
                      prefix: const Icon(Icons.search, color: Colors.grey),
                      onChanged: onChanged,
                      autoFocus: false,
                      controller: searchController,
                      readOnly: readOnly,
                    )
                  : const CustomImage(
                      "assets/images/title_bar_light.png",
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
                ? ((kDebugMode)
                    ? CustomDropdownFilter(
                        menuItems: filters!,
                        bgColor: Colors.white,
                        icon: Icons.filter_list_rounded,
                        onChanged: (value) {
                          filterController!.text = value!;
                        },
                      )
                    : const SizedBox())
                : CustomDropdownAction(
                    menuItems:
                        (ModalRoute.of(context)!.settings.name == "/profile")
                            ? ["Sign out"]
                            : profileActions,
                    bgColor: Colors.white,
                    isNetwork: true,
                    onChanged: (value) =>
                        _buildOnProfileDropdownValueChanged(value, context),
                    image: currentUser.avatar,
                  ),
          ],
        ),
      ],
    );
  }

  _buildOnProfileDropdownValueChanged(
      String? value, BuildContext context) async {
    if (value == 'Profile') {
      return Navigator.pushNamed(context, '/profile');
    }
    if (value == 'Sign out') {
      Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
    }
  }
}
