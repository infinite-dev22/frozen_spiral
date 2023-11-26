import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/pages/forms/requisition_form.dart';
import 'package:smart_case/services/apis/smartcase_apis/requisition_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/loading_widget/shimmers/requisition_shimmer.dart';
import 'package:smart_case/widgets/requisition_widget/requisition_item.dart';

import '../data/global_data.dart';
import '../models/smart_currency.dart';
import '../services/apis/smartcase_api.dart';
import '../util/smart_case_init.dart';
import '../widgets/better_toast.dart';
import '../widgets/custom_appbar.dart';

class RequisitionsPage extends StatefulWidget {
  const RequisitionsPage({super.key});

  @override
  State<RequisitionsPage> createState() => _RequisitionsPageState();
}

class _RequisitionsPageState extends State<RequisitionsPage> {
  late ScrollController _scrollController;

  TextEditingController filterController = TextEditingController();
  bool _doneLoading = false;
  bool _isLoading = false;
  bool _loadMoreData = true;
  // Timer? _timer;
  String? searchText;
  int _requisitionPage = 1;

  final scrollController = ScrollController();
  final gkey = GlobalKey<_RequisitionsPageState>();

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
    if (refreshRequisitions) {
      refreshRequisitions = false;
      RequisitionApi.fetchAll().then((value) {
        setState(() {});
      });
    }

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
          onChanged: (search) {
            _searchActivities(search);
            searchText = search;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buildRequisitionForm,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: LiquidPullToRefresh(
        onRefresh: _onRefresh,
        // springAnimationDurationInMilliseconds: 300,
        animSpeedFactor: 2,
        height: 40,
        borderWidth: 1,
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        child: _buildBody(),
        showChildOpacityTransition: false,
      ),
    );
  }

  _buildBody() {
    return (filteredRequisitions.isNotEmpty)
        ? _buildSearchedBody()
        : _buildNonSearchedBody();
  }

  _buildNonSearchedBody() {
    List<SmartRequisition> requisitions = preloadedRequisitions
        .where((requisition) =>
    ((requisition.requisitionStatus!.code.toLowerCase().contains("submit") ||
        requisition.requisitionStatus!.name
            .toLowerCase()
            .contains("submit")) &&
        requisition.supervisor!.id == currentUser.id) ||
        (requisition.employee!.id == currentUser.id) ||
        (requisition.canPay == true) ||
        ((requisition.secondApprover != null &&
            requisition.secondApprover == true) &&
            ((requisition.requisitionStatus!.code
                .toLowerCase()
                .contains("submit") ||
                requisition.requisitionStatus!.name
                    .toLowerCase()
                    .contains("submit")) ||
                (requisition.requisitionStatus!.code
                    .toLowerCase()
                    .contains("primar") ||
                    requisition.requisitionStatus!.name
                        .toLowerCase()
                        .contains("primar")) &&
                    (requisition.supervisor!.id == currentUser.id) ||
                (requisition.employee!.id == currentUser.id))))
        .toList(growable: true);

    // return SmartRefresher(
    //   enablePullDown: true,
    //   enablePullUp: true,
    //   header: const WaterDropHeader(
    //       refresh: CupertinoActivityIndicator(),
    //       waterDropColor: AppColors.primary),
    //   footer: CustomFooter(
    //     builder: (context, mode) {
    //       Widget body;
    //       if (mode == LoadStatus.idle) {
    //         body = const Text("more data");
    //       } else if (mode == LoadStatus.loading) {
    //         body = const CupertinoActivityIndicator();
    //       } else if (mode == LoadStatus.failed) {
    //         body = const Text("Load Failed! Pull up to retry");
    //       } else if (mode == LoadStatus.noMore) {
    //         body = const Text("That's all for now");
    //       } else {
    //         body = const Text("No more Data");
    //       }
    //       return SizedBox(
    //         height: 15,
    //         child: Center(child: body),
    //       );
    //     },
    //   ),
    //   controller: _refreshController,
    //   child: _buildBody(),
    //   onLoading: _onLoading,
    //   onRefresh: _onRefresh,
    //   enableTwoLevel: true,
    // );
    if ((requisitions.isNotEmpty)) {
      return Scrollbar(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: requisitions.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) =>
                RequisitionItem(
                  color: AppColors.white,
                  padding: 10,
                  requisition: requisitions.elementAt(index),
                  currencies: currencies,
                  showActions: true,
                  showFinancialStatus: true,
                ),)
      );
    } else if (_doneLoading && requisitions.isEmpty) {
      return const Center(
        child: Text(
          "Your requisitions appear here",
          style: TextStyle(color: AppColors.inActiveColor),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: 3,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) => const RequisitionShimmer(),
      );
    }
  }

  Widget _loadingWidget() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  Widget _emptyWidget() {
    return const Center(
      child: Text(
        "Your requisitions appear here",
        style: TextStyle(color: AppColors.inActiveColor),
      ),
    );
  }

  Widget _errorWidget() {
    return const Center(
      child: Text(
        "An error occurred",
        style: TextStyle(color: AppColors.inActiveColor),
      ),
    );
  }

  Widget _shimmerWidget() {
    return ListView.builder(
      itemCount: 3,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) => const RequisitionShimmer(),
    );
  }

  _buildSearchedBody() {
    List<SmartRequisition> requisitions = filteredRequisitions
        .where((requisition) =>
    ((requisition.requisitionStatus!.code
        .toLowerCase()
        .contains("submit") ||
        requisition.requisitionStatus!.name
            .toLowerCase()
            .contains("submit")) &&
        requisition.supervisor!.id == currentUser.id) ||
        (requisition.employee!.id == currentUser.id) ||
        (requisition.canPay == true) ||
        ((requisition.secondApprover != null &&
            requisition.secondApprover == true) &&
            ((requisition.requisitionStatus!.code
                .toLowerCase()
                .contains("submit") ||
                requisition.requisitionStatus!.name
                    .toLowerCase()
                    .contains("submit")) ||
                (requisition.requisitionStatus!.code
                    .toLowerCase()
                    .contains("primar") ||
                    requisition.requisitionStatus!.name
                        .toLowerCase()
                        .contains("primar")) &&
                    (requisition.supervisor!.id == currentUser.id) ||
                (requisition.employee!.id == currentUser.id))))
        .toList(growable: true);

    if ((requisitions.isNotEmpty)) {
      return SearchTextInheritedWidget(
        searchText: searchText,
        child: ListView.builder(
          itemCount: requisitions.length,
          padding: const EdgeInsets.all(8),
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
        ),
      );
    } else {
      return Center(
        child: Text("Requisition with ${filterController.text} can't be found"),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(_scrollListener);
    RequisitionApi.fetchAll().then((value) {
      _doneLoading = true;
      setState(() {});
    }).onError((error, stackTrace) {
      _doneLoading = true;
      const BetterErrorToast(
        text: "An error occurred",
      );
      if (mounted) setState(() {});
    });
    _loadCurrencies();

    // if (mounted) {
    //   _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
    //     RequisitionApi.fetchAll();
    //     setState(() {});
    //   });
    // }
  }

  _searchActivities(String value) {
    filteredRequisitions.clear();
    filteredRequisitions.addAll(preloadedRequisitions.where(
            (smartRequisition) =>
        smartRequisition.number!
            .toLowerCase()
            .contains(value.toLowerCase()) ||
            smartRequisition.caseFile!.fileName!
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            smartRequisition.caseFile!.fileNumber!
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            smartRequisition.requisitionStatus!.name
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            smartRequisition.requisitionStatus!.code
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            smartRequisition.supervisor!
                .getName()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            smartRequisition.payoutAmount!
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            smartRequisition.employee!
                .getName()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            smartRequisition.requisitionCategory!.name
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            (smartRequisition.description != null
                ? smartRequisition.description!
                .toLowerCase()
                .contains(value.toLowerCase())
                : false)));
    setState(() {});
  }

  _loadCurrencies() async {
    Map currencyMap = await SmartCaseApi.smartFetch(
        'api/admin/currencytypes', currentUser.token);
    List? currencyList = currencyMap["currencytypes"];
    if (mounted) {
      setState(() {
        currencies =
            currencyList!.map((doc) => SmartCurrency.fromJson(doc)).toList();
        currencyList = null;
      });
    }
  }

  Future<void> _onRefresh() async {
    await RequisitionApi.fetchAll().then((value) {
      _doneLoading = true;
      setState(() {});
    }).onError((error, stackTrace) {
      _doneLoading = true;
      const BetterErrorToast(
        text: "An error occurred",
      );
      setState(() {});
    });
  }

  _buildRequisitionForm() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => RequisitionForm(currencies: currencies),
    );
  }

  _fetchMoreData() {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadMoreData = false;
      });
    }

    if (_isLoading) {
      _requisitionPage++;
      print("Loading Page: $_requisitionPage");
      RequisitionApi.fetchAll(page: _requisitionPage).then((
          value) {
        setState(() {
          _isLoading = false;
          _loadMoreData = true;
        });
        print("Done loading!");
      }).onError((error, stackTrace) {
        setState(() {
          _isLoading = false;
          _loadMoreData = true;
        });
        print("An error whilst loading!");
      });
    }
  }

  @override
  void dispose() {
    // if (_timer != null) {
    //   _timer!.cancel();
    // }
    _scrollController.removeListener(_scrollListener);

    super.dispose();
  }

  void _scrollListener() {
    if (_loadMoreData) {
      if (_scrollController.position.extentAfter < 1200) {
        setState(() {
          _fetchMoreData();
        });
      }
    }
  }
}
