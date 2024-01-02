import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/custom_icon_holder.dart';
import 'package:smart_case/widgets/custom_image.dart';

class ProfileMasterItem extends StatelessWidget {
  const ProfileMasterItem({
    super.key,
    this.image,
    required this.isFile,
    required this.isNetwork,
    required this.color,
    required this.padding,
    this.changePhotoTap,
    this.changePasswordTap,
    required this.firstName,
    required this.lastName,
  });

  final dynamic image;
  final bool isFile;
  final bool isNetwork;
  final Color color;
  final double padding;
  final String firstName;
  final String lastName;
  final Function()? changePhotoTap;
  final Function()? changePasswordTap;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileImage(),
          _buildProfileFunctions(),
        ],
      ),
    );
  }

  _buildProfileImage() {
    return Column(
      children: [
        isNetwork
            ? CustomImage(
                image,
                isFile: isFile,
                isNetwork: isNetwork,
              )
            : const CustomIconHolder(
                width: 150,
                height: 150,
                graphic: Icons.account_circle,
                radius: 100,
                size: 150,
              ),
        const SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              firstName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(lastName),
          ],
        ),
      ],
    );
  }

  _buildProfileFunctions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        _buildProfileFunctionItem(
          Icons.image_rounded,
          "Change photo",
          changePhotoTap,
        ),
        const SizedBox(
          height: 20,
        ),
        _buildProfileFunctionItem(
          Icons.lock_rounded,
          "Change password",
          changePasswordTap,
        ),
      ],
    );
  }

  _buildProfileFunctionItem(IconData icon, String name, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 5,
          ),
          Text(
            name,
            style: const TextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
