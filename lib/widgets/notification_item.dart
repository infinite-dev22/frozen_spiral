import 'package:flutter/material.dart';

import '../theme/color.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({
    Key? key,
    required this.title,
    required this.time,
    required this.body,
  }) : super(key: key);

  final String title;
  final String time;
  final String body;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  late bool _showContent;

  final double _height = 200;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => setState(() {
        _showContent = !_showContent;
      }),
      child: Card(
        color: AppColors.white,
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                        color: AppColors.darker,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.time,
                    style: const TextStyle(
                      color: AppColors.inActiveColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _showContent
                  ? SizedBox(
                      height: _height,
                      child: Text(
                        widget.body,
                        style: const TextStyle(
                            color: AppColors.darker,
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  : Text(
                      widget.body,
                      style: const TextStyle(
                          color: AppColors.darker,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _showContent = false;
  }
}
