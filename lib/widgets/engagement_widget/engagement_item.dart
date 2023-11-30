import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/models/smart_engagement.dart';
import 'package:smart_case/widgets/engagement_widget/engagement_status_item.dart';
import 'package:smart_case/widgets/text_item.dart';

import '../../theme/color.dart';

class EngagementItem extends StatelessWidget {
  final SmartEngagement engagement;

  const EngagementItem({super.key, required this.engagement});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
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
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextItem(
                  title: 'Date',
                  data: DateFormat('dd/MM/yyyy').format(DateFormat('yyyy-MM-dd')
                      .parse(
                          DateFormat('yyyy-MM-dd').format(engagement.date!)))),
              TextItem(
                  title: 'Done by',
                  data: (engagement.doneBy!.lastOrNull != null)
                      ? engagement.doneBy!.last.getName()
                      : 'Null'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextItem(title: 'Client', data: engagement.client!.name!),
              TextItem(title: 'Cost', data: '${engagement.cost ?? '0.00'}/='),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (kDebugMode) _buildMediationStatusItem('Engagement'),
              TextItem(
                  title: 'Cost description',
                  data: engagement.costDescription ?? 'N/A'),
            ],
          ),
          TextItem(
              title: 'Engagement description', data: engagement.description!),
        ],
      ),
    );
  }

  // _buildBody() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     margin: const EdgeInsets.only(bottom: 20),
  //     decoration: BoxDecoration(
  //       borderRadius: const BorderRadius.all(
  //         Radius.circular(8),
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColors.shadowColor.withOpacity(.1),
  //           spreadRadius: 1,
  //           blurRadius: 1,
  //           offset: const Offset(0, 1), // changes position of shadow
  //         ),
  //       ],
  //       color: AppColors.white,
  //     ),
  //     child: Row(
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             TextItem(
  //                 title: 'Date',
  //                 data: DateFormat('dd/MM/YYYY')
  //                     .parse(DateFormat('yy-MM-dd').format(engagement.date!))
  //                     .toString()),
  //             TextItem(title: 'Client', data: engagement.client!.name!),
  //             _buildMediationStatusItem('Engagement'),
  //             TextItem(
  //                 title: 'Engagement description',
  //                 data: engagement
  //                     .description! /*and a bunch of other petty stuff*/),
  //           ],
  //         ),
  //         const Expanded(child: SizedBox()),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             TextItem(
  //                 title: 'Done by',
  //                 data: (engagement.doneBy!.lastOrNull != null)
  //                     ? engagement.doneBy!.last.getName()
  //                     : 'Null'),
  //             TextItem(title: 'Cost', data: engagement.cost ?? '0.00'),
  //             TextItem(
  //                 title: 'Cost description',
  //                 data: engagement.costDescription ?? 'N/A'),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  _buildMediationStatusItem(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.inActiveColor,
          ),
        ),
        const EngagementItemStatus(
            name: 'Coming soon...',
            bgColor: AppColors.inActiveColor,
            horizontalPadding: 20,
            verticalPadding: 5),
        const SizedBox(height: 5),
      ],
    );
  }
}
