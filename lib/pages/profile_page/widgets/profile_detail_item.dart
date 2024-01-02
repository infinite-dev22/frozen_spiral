import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/widgets/custom_icon_button.dart';

import 'package:smart_case/theme/color.dart';

class ProfileDetailItem extends StatelessWidget {
  const ProfileDetailItem(
      {super.key,
      required this.gender,
      required this.email,
      required this.personalEmail,
      required this.telephone,
      required this.dateOfBirth,
      required this.height,
      required this.code,
      required this.idNumber,
      required this.nssfNumber,
      required this.color,
      required this.padding,
      this.onPressed});

  final String gender;
  final String email;
  final String personalEmail;
  final String telephone;
  final String dateOfBirth;
  final dynamic height;
  final String? code;
  final String? idNumber;
  final String? nssfNumber;
  final Color color;
  final double padding;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          _buildTitle(),
          const SizedBox(
            height: 10,
          ),
          _buildBody(),
        ],
      ),
    );
  }

  _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomIconButton(onPressed: onPressed),
      ],
    );
  }

  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _profileDetailItem("Gender", gender),
        const SizedBox(height: 10),
        _profileDetailItem("Email", email),
        const SizedBox(height: 10),
        _profileDetailItem("Personal Email", personalEmail),
        const SizedBox(height: 10),
        _profileDetailItem("Telephone", telephone),
        const SizedBox(height: 10),
        _profileDetailItem(
            "Date of birth",
            DateFormat('dd/MM/yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(dateOfBirth))),
        const SizedBox(height: 10),
        _profileDetailItem("Height(cm)", height),
        const SizedBox(height: 10),
        _profileDetailItem("Code", code),
        const SizedBox(height: 10),
        _profileDetailItem("Id number", idNumber),
        const SizedBox(height: 10),
        _profileDetailItem("NSSF number", nssfNumber),
      ],
    );
  }

  _profileDetailItem(String name, var value) {
    return Row(
      children: [
        Text(
          '$name:',
          style: const TextStyle(color: AppColors.inActiveColor),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(value.toString(),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
