import 'package:flutter/material.dart';
import 'package:smart_case/widgets/profile/profile_detail_item.dart';
import 'package:smart_case/widgets/profile/profile_master_item.dart';

import '../data/data.dart';
import '../theme/color.dart';
import '../widgets/custom_appbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppBarContent(),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProfileMasterItem(
          image: profile['picture'],
          isFile: false,
          isNetwork: false,
          color: Colors.white,
          padding: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        ProfileDetailItem(
          gender: profile['gender'],
          email: profile['email'],
          personalEmail: profile['personal_email'],
          telephone: profile['telephone'],
          dateOfBirth: profile['dob'],
          height: profile['height'],
          code: profile['code'],
          idNumber: profile['id_number'],
          nssfNumber: profile['nssf_number'],
          color: Colors.white,
          padding: 20,
        ),
      ],
    );
  }
}
