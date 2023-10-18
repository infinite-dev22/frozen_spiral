import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/color.dart';
import 'custom_icon_bottom.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem(
      {super.key,
      required this.name,
      required this.date,
      required this.doneBy,
      required this.color,
      required this.padding,
      this.onPressed});

  final String name;
  final String date;
  final String doneBy;
  final Color color;
  final double padding;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(padding),
          margin: EdgeInsets.only(bottom: padding),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStringItem('Activity Name', name),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStringItem(
                      'Activity date',
                      date == 'Null'
                          ? 'Null'
                          : DateFormat("dd/MM/yyyy").format(
                              DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date))),
                  _buildStringItem('Done by', doneBy),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: MaterialButton(
            onPressed: onPressed,
            child: const CustomIconButton(),
          ),
        ),
      ],
    );
  }

  _buildStringItem(String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.inActiveColor,
          ),
        ),
        Text(
          data,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
