import 'package:flutter/material.dart';
import 'package:smart_case/models/smart_requisition.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/loading_widget/shimmers/requisition_shimmer.dart';
import 'package:smart_case/widgets/requisition_widget/requisition_item.dart';

import '../data/global_data.dart';
import '../models/smart_currency.dart';
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

  List<SmartRequisition> requisitions = List.empty(growable: true);
  List<SmartRequisition> filteredRequisitions = List.empty(growable: true);
  List<SmartCurrency> currencies = List.empty(growable: true);
  final List<String>? filters = [
    "File",
    "Number",
    "Category",
    "Currency",
    "Requester",
    "Supervisor",
    "Amount",
    "Amount (Payout)",
    "Status",
    "Status (Financial)",
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
          canNavigate: true,
          search: 'requisitions',
          filterController: filterController,
          filters: filters,
          onChanged: _searchActivities,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    if ((requisitions.isNotEmpty)) {
      return ListView.builder(
        itemCount: requisitions.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return RequisitionItem(
            color: AppColors.white,
            padding: 10,
            requisition: requisitions.elementAt(index),
            currencies: currencies,
            showActions: true,
            showFinancialStatus: true,
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: 3,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) => const RequisitionShimmer(),
      );
    }
  }

  Future<void> _setUpData() async {
    if (preloadedRequisitions.isEmpty) {
      Map requisitionMap = await SmartCaseApi.smartFetch(
          'api/accounts/cases/requisitions/allapi', currentUser.token);
      List requisitions = requisitionMap['search']['requisitions'];

      if (requisitions.isNotEmpty) {
        this.requisitions = requisitions
            .map(
              (requisition) => SmartRequisition.fromJson(requisition),
            )
            .toList();
        setState(() {});
      }
    } else if (preloadedRequisitions.isNotEmpty) {
      requisitions = preloadedRequisitions;
      setState(() {});
    }
  }

  @override
  void initState() {
    _setUpData();
    _loadCurrencies();

    filterController.text == 'Name';

    super.initState();
  }

  _searchActivities(String value) {
    filteredRequisitions.clear();
    if (filterController.text == 'Name') {
      filteredRequisitions.addAll(requisitions.where((requisition) =>
          requisition.caseFile!.fileName!
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    }

    if (filterController.text == 'Number') {
      filteredRequisitions.addAll(requisitions.where((smartRequisition) =>
          smartRequisition.number!
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Category') {
      filteredRequisitions.addAll(requisitions.where((smartRequisition) =>
          smartRequisition.requisitionCategory!
              .getName()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Currency') {
      filteredRequisitions.addAll(requisitions.where((smartRequisition) =>
          smartRequisition.currency!.name!
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Requester') {
      filteredRequisitions.addAll(requisitions.where((smartRequisition) =>
          smartRequisition.employee!
              .getName()
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Supervisor') {
      filteredRequisitions.addAll(requisitions.where((smartRequisition) =>
          smartRequisition.supervisor!
              .getName()
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Amount') {
      filteredRequisitions.addAll(requisitions.where((smartRequisition) =>
          smartRequisition.amount!
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Amount (Payout)') {
      filteredRequisitions.addAll(requisitions.where((smartRequisition) =>
          smartRequisition.payoutAmount!
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Status') {
      filteredRequisitions.addAll(requisitions.where((smartRequisition) =>
          smartRequisition.requisitionStatus!.name
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Status (Financial)') {
      filteredRequisitions.addAll(requisitions.where((smartRequisition) =>
          smartRequisition.caseFinancialStatus
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else {
      filteredRequisitions.addAll(requisitions.where((smartRequisition) =>
          smartRequisition.caseFile!
              .getName()
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    }
  }

  _loadCurrencies() async {
    Map currencyMap = await SmartCaseApi.smartFetch(
        'api/admin/currencytypes', currentUser.token);
    List? currencyList = currencyMap["currencytypes"];
    setState(() {
      currencies =
          currencyList!.map((doc) => SmartCurrency.fromJson(doc)).toList();
      currencyList = null;
    });
  }
}
