import 'package:flutter/material.dart';
import 'package:smart_case/models/smart_requisition.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/loading_widget/shimmers/requisition_shimmer.dart';
import 'package:smart_case/widgets/requisition_widget/requisition_item.dart';

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
        itemCount: 4,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) => const RequisitionShimmer(),
      );
    }
  }

  Future<void> _setUpData() async {
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
