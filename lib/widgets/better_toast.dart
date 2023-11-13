import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class BetterToast extends StatelessWidget {
  final ToastContext toast = ToastContext();
  final String text;

  BetterToast({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    toast.init(context);
    return _buildBody();
  }

  _buildBody() {
    return Toast.show(text, duration: Toast.lengthLong, gravity: Toast.bottom);
  }
}
