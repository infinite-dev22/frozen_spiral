import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../theme/color.dart';

class BetterSuccessToast extends StatelessWidget {
  final String text;

  const BetterSuccessToast({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return
      Fluttertoast.showToast(
          msg: text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.green,
          textColor: Colors.white,
          fontSize: 16.0);
  }
}

class BetterErrorToast extends StatelessWidget {
  final String text;

  const BetterErrorToast({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return
      Fluttertoast.showToast(
          msg: text,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.green,
          textColor: Colors.white,
          fontSize: 16.0);
  }
}
