import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/models/smart_requisition.dart';
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

  List<Requisition> requisitions = List.empty(growable: true);
  List<Requisition> filteredRequisitions = List.empty(growable: true);

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
          onChanged: _searchActivities,
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
          color: AppColors.white,
          padding: 10,
          requisition: requisitions.elementAt(index),
        );
      },
    );
  }

  Future<void> _setUpData() async {
    Map requisitionMap = await SmartCaseApi.smartFetch(
        'api/accounts/cases/requisitions/all', currentUser.token);
    List? requisitions = requisitionMap['search']['requisitions'];
    this.requisitions = requisitions!
        .map((requisition) => Requisition(
            id: requisition['id'],
            date: DateFormat('yyyy-MM-dd').parse(requisition['date']),
            amount: requisition['amount'],
            description: requisition['description'],
            number: requisition['number'],
            canApprove: requisition['canApprove'],
            canEdit: requisition['canEdit'],
            isMine: requisition['isMine'],
            canPay: requisition['canPay'],
            employee: Employee(
                firstName: requisition['employee']['first_name'],
                lastName: requisition['employee']['last_name']),
            supervisor: Employee(
                firstName: requisition['supervisor']['first_name'],
                lastName: requisition['employee']['last_name']),
            caseFile: CaseFile(
                id: requisition['case_file']['id'],
                fileName: requisition['case_file']['file_name'],
                fileNumber: requisition['case_file']['file_number'],
                courtFileNumber: requisition['case_file']['court_file_number']),
            requisitionCategory: requisition['requisition_category']['name'],
            currency: requisition['currency']['code'],
            requisitionStatus: RequisitionStatus(
                name: requisition['requisition_actions'][0]
                    ['requisition_status']['name'],
                code: requisition['requisition_actions'][0]
                    ['requisition_status']['code']),
            requisitionWorkflow: requisition['requisition_workflow']))
        .toList();
    // setState(() {
    //   requisitions = null;
    // });
  }

  @override
  void initState() {
    _setUpData();

    filterController.text == 'Name';

    super.initState();
  }

  _searchActivities(String value) {
    filteredRequisitions.clear();
    if (filterController.text == 'Name') {
      filteredRequisitions.addAll(requisitions.where((requisition) =>
          requisition.caseFile.fileName
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    }
  }
}
