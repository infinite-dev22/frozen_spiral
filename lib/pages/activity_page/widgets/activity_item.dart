import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/pages/activity_page/widgets/activity_form.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_icon_button.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem({
    super.key,
    required this.activity,
    required this.color,
    required this.padding,
    this.onTap,
  });

  final SmartActivity activity;
  final Color color;
  final double padding;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
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
                _buildStringItem('File Name', activity.file!.getName()),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStringItem(
                        'Activity date',
                        activity.date == null
                            ? 'Null'
                            : DateFormat('dd/MM/yyyy').format(activity.date!)),
                    _buildStringItem('Done by',
                        '${activity.employee!.firstName} ${activity.employee!.lastName}'),
                  ],
                ),
              ],
            ),
          ),
          if (activity.createdBy == currentUser.id)
            Positioned(
              right: 0,
              top: 0,
              child: MaterialButton(
                padding: const EdgeInsets.all(5),
                onPressed: () => _onPressed(context),
                child: const CustomIconButton(),
              ),
            ),
        ],
      ),
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

  _buildStringItem(String title, String? data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.inActiveColor,
          ),
        ),
        SearchHighlightText(
          data ?? 'Null',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            // fontWeight: FontWeight.bold,
            color: AppColors.darker,
          ),
          highlightStyle: const TextStyle(
            // fontSize: 14,
            // fontWeight: FontWeight.bold,
            color: AppColors.darker,
            backgroundColor: AppColors.searchText,
          ),
        ),
      ],
    );
  }
}
