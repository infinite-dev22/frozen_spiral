import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

class ViewLoadingWidget extends StatelessWidget {
  const ViewLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: _buildBody(),
    );
  }

  _buildBody() {
    return const Center(
      child: CupertinoActivityIndicator(radius: 20),
    );
  }
}
