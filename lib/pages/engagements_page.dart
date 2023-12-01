import 'package:flutter/cupertino.dart';
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
  final List<String>? filters = [
    "Client",
    "Type",
    "Cost",
    "Done By",
    "Description (Cost)",
    "Date",
  ];

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
          onChanged: _searchFiles,
          filters: filters,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return (filteredEngagements.isEmpty)
        ? _buildNonSearchedBody()
        : _buildSearchedBody();
  }

  _buildNonSearchedBody() {
    return (engagements.isNotEmpty)
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
            child: CupertinoActivityIndicator(radius: 20),
          );
  }

  _buildSearchedBody() {
    return (filteredEngagements.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              top: 16,
              right: 10,
              bottom: 80,
            ),
            itemCount: filteredEngagements.length,
            itemBuilder: (context, index) =>
                EngagementItem(engagement: filteredEngagements[index]),
          )
        : const Center(
            child: Text('No result found'),
          );
  }

  Future<void> _setUpData() async {
    Map response = await SmartCaseApi.smartFetch(
        'api/crm/engagementsgetall', currentUser.token);
    List engagementsList = response["engagements"];
    engagements =
        engagementsList.map((doc) => SmartEngagement.fromJson(doc)).toList();

    filterController.text == 'Name';
    if (mounted) setState(() {});
  }

  Future<void> getUser(int userId) async {
    Map response = await SmartCaseApi.smartFetch(
        'api/crm/clients/$userId', currentUser.token);
    client = SmartClient.fromJson(response["client"]);
    setState(() {});
  }

  _searchFiles(String value) {
    filteredEngagements.clear();
    if (filterController.text == 'Type') {
      filteredEngagements.addAll(engagements.where((smartEngagement) =>
          smartEngagement.engagementType!
              .getName()
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Cost') {
      filteredEngagements.addAll(engagements.where((smartEngagement) =>
          smartEngagement.cost!.toLowerCase().contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Done By') {
      filteredEngagements.addAll(engagements.where((smartEngagement) =>
          smartEngagement.doneBy!.last
              .getName()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Description (Cost)') {
      filteredEngagements.addAll(engagements.where((smartEngagement) =>
          smartEngagement.costDescription!
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Date') {
      filteredEngagements.addAll(engagements.where((smartEngagement) =>
          smartEngagement.date!
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else {
      filteredEngagements.addAll(engagements.where((smartEngagement) =>
          smartEngagement.client!
              .getName()
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    }
  }

  @override
  void initState() {
    _setUpData();

    super.initState();
  }
}
