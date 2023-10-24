import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/requisition/requisition_item.dart';

import '../services/apis/smartcase_api.dart';
import '../util/smart_case_init.dart';
import '../widgets/custom_appbar.dart';

class RequisitionsPage extends StatefulWidget {
  const RequisitionsPage({super.key});

  @override
  State<RequisitionsPage> createState() => _RequisitionsPageState();
}

class _RequisitionsPageState extends State<RequisitionsPage> {
  TextEditingController filterController = TextEditingController();

  List requisitions = List.empty(growable: true);
  List filteredRequisitions = List.empty(growable: true);

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
          search: 'requisitions',
          filterController: filterController,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView.builder(
      itemCount: requisitions.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return RequisitionItem(
          fileName: requisitions[index]['case_file']['file_name'],
          requisitionNumber: requisitions[index]['number'],
          dateCreated: requisitions[index]['date'],
          color: AppColors.white,
          padding: 10,
          status: requisitions[index]['requisition_actions'][0]
              ['requisition_status']['name'],
          category: requisitions[index]['requisition_category']['name'],
          description: requisitions[index]['description'],
          requesterName:
              "${requisitions[index]['employee']['first_name']} ${requisitions[index]['employee']['last_name']}",
          supervisorName:
              "${requisitions[index]['supervisor']['first_name']} ${requisitions[index]['supervisor']['last_name']}",
          amount: requisitions[index]['amount'],
          statusCode: requisitions[index]['requisition_actions'][0]
              ['requisition_status']['code'],
          isMine: requisitions[index]['isMine'],
          canApprove: requisitions[index]['canApprove'],
          canPay: requisitions[index]['canPay'],
        );
      },
    );
    return const Center(
      child: Text(
        'Your requisitions appear here',
        style: TextStyle(color: AppColors.inActiveColor),
      ),
    );
  }

  // _buildTestBody() {
  //   return ListView(padding: const EdgeInsets.all(10), children: [
  //     const RequisitionItem(
  //         fileName: "fileName",
  //         requisitionNumber: "requisitionNumber",
  //         dateCreated: "dateCreated",
  //         color: AppColors.white,
  //         padding: 10,
  //         status: "status",
  //         category: "category",
  //         description: "description",
  //         requesterName: "requesterName",
  //         supervisorName: "supervisorName",
  //         amount: "amount"),
  //   ]);
  // }

  Future<void> _setUpData() async {
    Map requisitionMap = await SmartCaseApi.smartFetch(
        'api/accounts/cases/requisitions/all', currentUser.token);
    List? requisitions = requisitionMap['search']['requisitions'];
    setState(() {
      this.requisitions = requisitions!;
      requisitions = null;
    });

    filterController.text == 'Name';
  }

  @override
  void initState() {
    _setUpData();

    super.initState();
  }

  _searchActivities(String value) {
    filteredRequisitions.clear();
    if (filterController.text == 'Name') {
      filteredRequisitions.addAll(requisitions.where((requisitionMap) =>
          requisitionMap['case_file']['file_name']
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    }
  }
}
