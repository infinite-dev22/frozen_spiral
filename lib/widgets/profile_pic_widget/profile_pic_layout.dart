import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/profile_pic_widget/bloc/profile_pic_bloc.dart';
import 'package:smart_case/widgets/profile_pic_widget/widgets/no_pic.dart';
import 'package:smart_case/widgets/profile_pic_widget/widgets/pic_error.dart';
import 'package:smart_case/widgets/profile_pic_widget/widgets/pic_loading.dart';
import 'package:smart_case/widgets/profile_pic_widget/widgets/pic_success.dart';

class ProfilePicLayout extends StatefulWidget {
  const ProfilePicLayout({
    super.key,
    this.width = 100,
    this.height = 100,
    this.radius = 50,
  });

  final double width;
  final double height;
  final double radius;

  @override
  State<ProfilePicLayout> createState() => _ProfilePicLayoutState();
}

class _ProfilePicLayoutState extends State<ProfilePicLayout> {
  final _profilePicBloc = ProfilePicBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePicBloc, ProfilePicState>(
      bloc: _profilePicBloc,
      builder: (BuildContext context, ProfilePicState state) {
        print("State is Initial: ${state.status == ProfilePicStatus.initial}");
        print("State is Success: ${state.status == ProfilePicStatus.success}");
        print("State is Loading: ${state.status == ProfilePicStatus.loading}");
        print("State is Error: ${state.status == ProfilePicStatus.error}");
        if (state.status == ProfilePicStatus.initial) {
          _profilePicBloc.add(GetProfilePic());
        }
        if (state.status == ProfilePicStatus.success) {
          if (state.imageUrl != null) {
            return PicSuccess(
              state.file,
              state.imageUrl!,
              width: widget.width,
              height: widget.height,
              radius: widget.radius,
            );
          } else {
            return NoPic(
              width: widget.width,
              height: widget.height,
              radius: widget.radius,
              bgColor: AppColors.white,
            );
          }
        }
        if (state.status == ProfilePicStatus.loading) {
          return PicLoading(
            width: widget.width,
            height: widget.height,
            radius: widget.radius,
            bgColor: AppColors.white,
          );
        }
        if (state.status == ProfilePicStatus.error) {
          return PicError(
            width: widget.width,
            height: widget.height,
            radius: widget.radius,
            bgColor: AppColors.white,
          );
        } else {
          return NoPic(
            width: widget.width,
            height: widget.height,
            radius: widget.radius,
            bgColor: AppColors.white,
          );
        }
      },
    );
  }
}
