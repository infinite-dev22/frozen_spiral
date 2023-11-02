import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/models/smart_activity.dart';

import '../../../theme/color.dart';
import '../../pages/forms/activity_form.dart';
import '../../util/smart_case_init.dart';
import '../custom_icon_button.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem({
    super.key,
    required this.activity,
    required this.color,
    required this.padding,
  });

  final SmartActivity activity;
  final Color color;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
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
              _buildStringItem('Activity Name', activity.name!),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStringItem(
                      'Activity date',
                      activity.activityDate == null
                          ? 'Null'
                          : DateFormat("dd/MM/yyyy").format(
                              DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                  .parse(activity.activityDate!))),
                  _buildStringItem('Done by',
                      '${currentUser.firstName} ${currentUser.middleName ?? ''} ${currentUser.lastName}'),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: MaterialButton(
            onPressed: () => _onPressed(context),
            child: const CustomIconButton(),
          ),
        ),
      ],
    );
  }

  _onPressed(BuildContext context) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      backgroundColor: AppColors.appBgColor,
      builder: (context) => ActivityForm(
        activity: activity,
      ),
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
