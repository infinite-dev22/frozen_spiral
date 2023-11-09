import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/models/smart_engagement.dart';
import 'package:smart_case/widgets/engagement_widget/engagement_item.dart';

import '../models/smart_client.dart';
import '../services/apis/smartcase_api.dart';
import '../theme/color.dart';
import '../util/smart_case_init.dart';
import '../widgets/custom_appbar.dart';

class EngagementsPage extends StatefulWidget {
  const EngagementsPage({super.key});

  @override
  State<EngagementsPage> createState() => _EngagementsPageState();
}

class _EngagementsPageState extends State<EngagementsPage> {
  late SmartClient client;
  TextEditingController filterController = TextEditingController();

  List<SmartEngagement> engagements = List.empty(growable: true);
  List<SmartEngagement> filteredEngagements = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          searchable: true,
          filterable: true,
          search: 'engagements',
          filterController: filterController,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return (kDebugMode)
        ? (engagements.isNotEmpty)
            ? ListView.builder(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 16,
                  right: 10,
                  bottom: 80,
                ),
                itemCount: engagements.length,
                itemBuilder: (context, index) =>
                    EngagementItem(engagement: engagements[index]),
              )
            : const Center(
                child: CircularProgressIndicator(),
              )
        : const Center(
            child: Text(
              'Coming soon...',
              style: TextStyle(color: AppColors.inActiveColor),
            ),
          );
  }

  Future<void> _setUpData() async {
    Map response = await SmartCaseApi.smartFetch(
        'api/crm/engagementsgetall', currentUser.token);
    List engagementsList = response["engagements"];
    engagements =
        engagementsList.map((doc) => SmartEngagement.fromJson(doc)).toList();

    filterController.text == 'Name';
    setState(() {});
  }

  Future<void> getUser(int userId) async {
    Map response = await SmartCaseApi.smartFetch(
        'api/crm/clients/$userId', currentUser.token);
    client = SmartClient.fromJson(response["client"]);
    setState(() {});
  }

  @override
  void initState() {
    _setUpData();

    super.initState();
  }
}
