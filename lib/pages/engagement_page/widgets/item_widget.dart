import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/database/engagement/engagement_model.dart';
import 'package:smart_case/pages/engagement_page/widgets/status_item_widget.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/text_item.dart';

class ItemWidget extends StatelessWidget {
  final SmartEngagement engagement;

  const ItemWidget({super.key, required this.engagement});

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
          if (engagement.description != null)
            TextItem(
                title: 'Engagement description', data: engagement.description!),
        ],
      ),
    );
  }

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
        const ItemStatusWidget(
            name: 'Coming soon...',
            bgColor: AppColors.inActiveColor,
            horizontalPadding: 20,
            verticalPadding: 5),
        const SizedBox(height: 5),
      ],
    );
  }
}
