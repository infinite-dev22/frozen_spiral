import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/widgets/profile_pic_widget/bloc/profile_pic_bloc.dart';
import 'package:smart_case/widgets/profile_pic_widget/profile_pic_layout.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    this.width = 100,
    this.height = 100,
    this.radius = 50,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfilePicBloc(),
      child: ProfilePicLayout(
        width: width,
        height: height,
        radius: radius,
      ),
    );
  }
}
