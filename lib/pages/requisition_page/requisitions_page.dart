import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/pages/requisition_page/widgets/requisition_appbar.dart';
import 'package:smart_case/pages/requisition_page/widgets/requisition_form.dart';
import 'package:smart_case/pages/requisition_page/widgets/requisition_item.dart';
import 'package:smart_case/pages/requisition_page/widgets/requisition_shimmer.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/requisition_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';

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

  Timer? _timer;
  String? _searchText;
  int _requisitionPage = 1;

  bool _allFilter = false;
  bool _submittedFilter = false;
  bool _approvedFilter = false;
  bool _preApprovedFilter = false;
  bool _rejectedFilter = false;
  bool _returnedFilter = false;

  final List<SmartRequisition> _searchedRequisitions =
      List.empty(growable: true);
  final List<SmartRequisition> _filteredRequisitions =
      List.empty(growable: true);
  final List<SmartCurrency> _currencies = List.empty(growable: true);

  List<DropdownMenuItem> _filters() {
    return [
      if (canApprove)
        DropdownMenuItem<String>(
          alignment: Alignment.centerLeft,
          value: "All",
          child: Row(
            children: [
              CupertinoCheckbox(
                value: _allFilter,
                onChanged: (bool? value) {
                  setState(() {
                    _allFilter = value!;
                    _buildFilteredList();
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _allFilter = !_allFilter;
                    _buildFilteredList();
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  "All",
                  style: TextStyle(
                    color: AppColors.darker,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      DropdownMenuItem<String>(
        value: "Submitted",
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            CupertinoCheckbox(
              value: _submittedFilter,
              onChanged: (bool? value) {
                setState(() {
                  _submittedFilter = value!;
                  _approvedFilter = false;
                  _preApprovedFilter = false;
                  _rejectedFilter = false;
                  _returnedFilter = false;
                  _buildFilteredList();
                  Navigator.pop(context);
                });
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _submittedFilter = !_submittedFilter;
                  _approvedFilter = false;
                  _preApprovedFilter = false;
                  _rejectedFilter = false;
                  _returnedFilter = false;
                  _buildFilteredList();
                  Navigator.pop(context);
                });
              },
              child: const Text(
                "Submitted",
                style: TextStyle(
                  color: AppColors.darker,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      DropdownMenuItem<String>(
        value: "Approved",
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            CupertinoCheckbox(
              value: _approvedFilter,
              onChanged: (bool? value) {
                setState(() {
                  _approvedFilter = value!;
                  _submittedFilter = false;
                  _preApprovedFilter = false;
                  _rejectedFilter = false;
                  _returnedFilter = false;
                  _buildFilteredList();
                  Navigator.pop(context);
                });
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _approvedFilter = !_approvedFilter;
                  _submittedFilter = false;
                  _preApprovedFilter = false;
                  _rejectedFilter = false;
                  _returnedFilter = false;
                  _buildFilteredList();
                  Navigator.pop(context);
                });
              },
              child: const Text(
                "Approved",
                style: TextStyle(
                  color: AppColors.darker,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      if (flowType == "LV2")
        DropdownMenuItem<String>(
          value: "Pre-Approved",
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              CupertinoCheckbox(
                value: _preApprovedFilter,
                onChanged: (bool? value) {
                  setState(() {
                    _preApprovedFilter = value!;
                    _submittedFilter = false;
                    _approvedFilter = false;
                    _rejectedFilter = false;
                    _returnedFilter = false;
                    _buildFilteredList();
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _preApprovedFilter = !_preApprovedFilter;
                    _submittedFilter = false;
                    _approvedFilter = false;
                    _rejectedFilter = false;
                    _returnedFilter = false;
                    _buildFilteredList();
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  "Pre-Approved",
                  style: TextStyle(
                    color: AppColors.darker,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      DropdownMenuItem<String>(
        value: "Rejected",
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            CupertinoCheckbox(
              value: _rejectedFilter,
              onChanged: (bool? value) {
                setState(() {
                  _rejectedFilter = value!;
                  _submittedFilter = false;
                  _approvedFilter = false;
                  _preApprovedFilter = false;
                  _returnedFilter = false;
                  _buildFilteredList();
                  Navigator.pop(context);
                });
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _rejectedFilter = !_rejectedFilter;
                  _submittedFilter = false;
                  _approvedFilter = false;
                  _preApprovedFilter = false;
                  _returnedFilter = false;
                  _buildFilteredList();
                  Navigator.pop(context);
                });
              },
              child: const Text(
                "Rejected",
                style: TextStyle(
                  color: AppColors.darker,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      DropdownMenuItem<String>(
        value: "Returned",
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            CupertinoCheckbox(
              value: _returnedFilter,
              onChanged: (bool? value) {
                setState(() {
                  _returnedFilter = value!;
                  _submittedFilter = false;
                  _approvedFilter = false;
                  _preApprovedFilter = false;
                  _rejectedFilter = false;
                  _buildFilteredList();
                  Navigator.pop(context);
                });
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _returnedFilter = !_returnedFilter;
                  _submittedFilter = false;
                  _approvedFilter = false;
                  _preApprovedFilter = false;
                  _rejectedFilter = false;
                  _buildFilteredList();
                  Navigator.pop(context);
                });
              },
              child: const Text(
                "Returned",
                style: TextStyle(
                  color: AppColors.darker,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

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
        title: RequisitionAppBar(
          search: 'requisitions',
          filterController: filterController,
          filters: _filters(),
          onChanged: (search) {
            _searchActivities(search);
            _searchText = search;
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
    return (_searchedRequisitions.isNotEmpty)
        ? _buildSearchedBody()
        : _buildNonSearchedBody();
  }

  _buildFilteredList() {
    _filteredRequisitions.clear();
    _filteredRequisitions.addAll(preloadedRequisitions.where((requisition) => (!_allFilter &&
            !_submittedFilter &&
            !_approvedFilter &&
            !_preApprovedFilter &&
            !_rejectedFilter &&
            !_returnedFilter)
        ? (((requisition.requisitionStatus!.code.toLowerCase().contains("submit") ||
                    requisition.requisitionStatus!.name
                        .toLowerCase()
                        .contains("submit")) &&
                requisition.supervisor!.id == currentUser.id) ||
            (requisition.employee!.id == currentUser.id) ||
            (requisition.canPay == true) ||
            ((requisition.secondApprover != null &&
                    requisition.secondApprover == true) &&
                (((requisition.requisitionStatus!.code.toLowerCase().contains("submit") ||
                            requisition.requisitionStatus!.name
                                .toLowerCase()
                                .contains("submit")) &&
                        (requisition.supervisor!.id == currentUser.id)) ||
                    (requisition.requisitionStatus!.code
                            .toLowerCase()
                            .contains("primary_approved") ||
                        requisition.requisitionStatus!.name
                            .toLowerCase()
                            .contains("primary approved"))
                //     && ((requisition.supervisor!.id == currentUser.id) ||
                // (requisition.employee!.id == currentUser.id))
                )))
        : (_allFilter &&
                !_submittedFilter &&
                !_approvedFilter &&
                !_preApprovedFilter &&
                !_rejectedFilter &&
                !_returnedFilter)
            ? ((canApprove) ? (true) : requisition.employee!.id == currentUser.id)
            : ((_submittedFilter)
                ? ((requisition.requisitionStatus!.code.toLowerCase().contains("submit") || requisition.requisitionStatus!.name.toLowerCase().contains("submit")) && (_allFilter ? (true) : ((canApprove) ? (requisition.employee!.id == currentUser.id || requisition.supervisor!.id == currentUser.id) : requisition.employee!.id == currentUser.id)))
                : (_approvedFilter)
                    ? (((requisition.requisitionStatus!.code.toLowerCase() == "approved" || requisition.requisitionStatus!.name.toLowerCase() == "approved") && (_allFilter ? (true) : ((canApprove) ? (requisition.employee!.id == currentUser.id || requisition.supervisor!.id == currentUser.id) : requisition.employee!.id == currentUser.id))))
                    : (_preApprovedFilter)
                        ? ((requisition.requisitionStatus!.code.toLowerCase().contains("primary_approved") || requisition.requisitionStatus!.name.toLowerCase().contains("primary approved")))
                        : (_rejectedFilter)
                            ? (((requisition.requisitionStatus!.code.toLowerCase().contains("rejected") || requisition.requisitionStatus!.name.toLowerCase().contains("rejected")) && (_allFilter ? (true) : ((canApprove) ? (requisition.employee!.id == currentUser.id || requisition.supervisor!.id == currentUser.id) : requisition.employee!.id == currentUser.id))))
                            : (_returnedFilter)
                                ? (((requisition.requisitionStatus!.code.toLowerCase().contains("returned") || requisition.requisitionStatus!.name.toLowerCase().contains("returned")) && (_allFilter ? (true) : ((canApprove) ? (requisition.employee!.id == currentUser.id || requisition.supervisor!.id == currentUser.id) : requisition.employee!.id == currentUser.id))))
                                : false)));
  }

  _buildNonSearchedBody() {
    if ((_filteredRequisitions.isNotEmpty)) {
      return Scrollbar(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _filteredRequisitions.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) => RequisitionItem(
            color: AppColors.white,
            padding: 10,
            requisition: _filteredRequisitions.elementAt(index),
            currencies: _currencies,
            showActions: true,
            showFinancialStatus: true,
          ),
        ),
      );
    } else if (_doneLoading && _filteredRequisitions.isEmpty) {
      return const Center(
        child: Text(
          "No new requisitions",
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

  _buildSearchedBody() {
    List<SmartRequisition> requisitions = _searchedRequisitions
        .where((requisition) =>
            ((requisition.requisitionStatus!.code.toLowerCase().contains("submit") ||
                    requisition.requisitionStatus!.name
                        .toLowerCase()
                        .contains("submit")) &&
                requisition.supervisor!.id == currentUser.id) ||
            (requisition.employee!.id == currentUser.id) ||
            (requisition.canPay == true) ||
            ((requisition.secondApprover != null && requisition.secondApprover == true) &&
                ((requisition.requisitionStatus!.code.toLowerCase().contains("submit") ||
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
        searchText: _searchText,
        child: ListView.builder(
          itemCount: requisitions.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return RequisitionItem(
              color: AppColors.white,
              padding: 10,
              requisition: requisitions.elementAt(index),
              currencies: _currencies,
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

    _scrollController = ScrollController()..addListener(_scrollListener);
    RequisitionApi.fetchAll().then((value) {
      _doneLoading = true;
      setState(() {});
    }).onError((error, stackTrace) {
      _doneLoading = true;
      Fluttertoast.showToast(
          msg: "An error occurred",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.red,
          textColor: AppColors.white,
          fontSize: 16.0);
      if (mounted) setState(() {});
    });

    // Not sure if this is what is actually needed for better UX.
    // For now I will just comment it out.
    // if (canApprove) {
    //   _allFilter = true;
    //   _submittedFilter = true;
    // }

    _loadCurrencies();
    _buildFilteredList();

    if (mounted) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        RequisitionApi.fetchAll();
        _buildFilteredList();
        setState(() {});
      });
    }
  }

  _searchActivities(String value) {
    _buildFilteredList();
    _searchedRequisitions.clear();
    _searchedRequisitions.addAll(_filteredRequisitions.where(
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
    _currencies.clear();

    if (currencyList != null) {
      _currencies.addAll(
          currencyList.map((doc) => SmartCurrency.fromJson(doc)).toList());
    }

    currencyList = null;

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onRefresh() async {
    await RequisitionApi.fetchAll().then((value) {
      _doneLoading = true;
      setState(() {});
    }).onError((error, stackTrace) {
      _doneLoading = true;
      Fluttertoast.showToast(
          msg: "An error occurred",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.red,
          textColor: AppColors.white,
          fontSize: 16.0);
      setState(() {});
    });
  }

  _buildRequisitionForm() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => RequisitionForm(currencies: _currencies),
    );
  }

  _fetchMoreData() {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadMoreData = false;
      });
    }

    if (_isLoading &&
        _requisitionPage <= (pagesLength ?? _requisitionPage + 1)) {
      // add ?? _requisitionPage + 1
      _requisitionPage++;
      RequisitionApi.fetchAll(page: _requisitionPage).then((value) {
        setState(() {
          _isLoading = false;
          _loadMoreData = true;
        });
      }).onError((error, stackTrace) {
        setState(() {
          _isLoading = false;
          _loadMoreData = true;
        });
      });
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
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
