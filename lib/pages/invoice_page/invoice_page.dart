import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/pages/invoice_page/forms/invoice_form.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_appbar.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_item.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_shimmer.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  late ScrollController _scrollController;

  TextEditingController filterController = TextEditingController();
  bool _doneLoading = false;
  bool _isLoading = false;
  bool _loadMoreData = true;

  Timer? _timer;
  String? _searchText;
  int _invoicePage = 1;

  bool _allFilter = false;
  bool _submittedFilter = false;
  bool _approvedFilter = false;
  bool _preApprovedFilter = false;
  bool _rejectedFilter = false;
  bool _returnedFilter = false;

  final List<SmartInvoice> _searchedInvoice = List.empty(growable: true);
  final List<SmartInvoice> _filteredInvoice = List.empty(growable: true);
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
    if (refreshInvoices) {
      refreshInvoices = false;
      InvoiceApi.fetchAll().then((value) {
        setState(() {});
      });
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: InvoiceAppBar(
          search: 'invoices',
          filterController: filterController,
          filters: _filters(),
          onChanged: (search) {
            _searchActivities(search);
            _searchText = search;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buildInvoiceForm,
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
    return (_searchedInvoice.isNotEmpty)
        ? _buildSearchedBody()
        : _buildNonSearchedBody();
  }

  _buildFilteredList() {
    _filteredInvoice.clear();
    _filteredInvoice.addAll(preloadedInvoices.where((invoice) => (!_allFilter &&
            !_submittedFilter &&
            !_approvedFilter &&
            !_preApprovedFilter &&
            !_rejectedFilter &&
            !_returnedFilter)
        ? (/*((invoice.invoiceStatus!.code.toLowerCase().contains("submit") || invoice.invoiceStatus!.name.toLowerCase().contains("submit")) &&
                invoice.approver!.id == currentUser.id) ||*/
            (invoice.employee!.id == currentUser.id) ||
            (invoice.canPay == true) ||
            ((invoice.secondApprover != null &&
                    invoice.secondApprover == true) &&
                (((invoice.invoiceStatus!.code.toLowerCase().contains("submit") || invoice.invoiceStatus!.name.toLowerCase().contains("submit")) &&
                        (invoice.approver!.id == currentUser.id)) ||
                    (invoice.invoiceStatus!.code.toLowerCase().contains("primary_approved") ||
                        invoice.invoiceStatus!.name
                            .toLowerCase()
                            .contains("primary approved"))
                //     && ((invoice.approver!.id == currentUser.id) ||
                // (invoice.employee!.id == currentUser.id))
                )))
        : (_allFilter &&
                !_submittedFilter &&
                !_approvedFilter &&
                !_preApprovedFilter &&
                !_rejectedFilter &&
                !_returnedFilter)
            ? ((canApprove) ? (true) : invoice.employee!.id == currentUser.id)
            : ((_submittedFilter)
                ? ((invoice.invoiceStatus!.code.toLowerCase().contains("submit") ||
                        invoice.invoiceStatus!.name
                            .toLowerCase()
                            .contains("submit")) &&
                    (_allFilter
                        ? (true)
                        : ((canApprove)
                            ? (invoice.employee!.id == currentUser.id || invoice.approver!.id == currentUser.id)
                            : invoice.employee!.id == currentUser.id)))
                : (_approvedFilter)
                    ? (((invoice.invoiceStatus!.code.toLowerCase() == "approved" || invoice.invoiceStatus!.name.toLowerCase() == "approved") && (_allFilter ? (true) : ((canApprove) ? (invoice.employee!.id == currentUser.id || invoice.approver!.id == currentUser.id) : invoice.employee!.id == currentUser.id))))
                    : (_preApprovedFilter)
                        ? ((invoice.invoiceStatus!.code.toLowerCase().contains("primary_approved") || invoice.invoiceStatus!.name.toLowerCase().contains("primary approved")))
                        : (_rejectedFilter)
                            ? (((invoice.invoiceStatus!.code.toLowerCase().contains("rejected") || invoice.invoiceStatus!.name.toLowerCase().contains("rejected")) && (_allFilter ? (true) : ((canApprove) ? (invoice.employee!.id == currentUser.id || invoice.approver!.id == currentUser.id) : invoice.employee!.id == currentUser.id))))
                            : (_returnedFilter)
                                ? (((invoice.invoiceStatus!.code.toLowerCase().contains("returned") || invoice.invoiceStatus!.name.toLowerCase().contains("returned")) && (_allFilter ? (true) : ((canApprove) ? (invoice.employee!.id == currentUser.id || invoice.approver!.id == currentUser.id) : invoice.employee!.id == currentUser.id))))
                                : false)));
  }

  _buildNonSearchedBody() {
    if ((_filteredInvoice.isNotEmpty)) {
      return Scrollbar(
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _filteredInvoice.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) => InvoiceItem(
            color: AppColors.white,
            padding: 10,
            invoice: _filteredInvoice.elementAt(index),
            currencies: _currencies,
            showActions: true,
            showFinancialStatus: true,
          ),
        ),
      );
    } else if (_doneLoading && _filteredInvoice.isEmpty) {
      return const Center(
        child: Text(
          "No new invoices",
          style: TextStyle(color: AppColors.inActiveColor),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: 3,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) => const InvoiceShimmer(),
      );
    }
  }

  _buildSearchedBody() {
    List<SmartInvoice> invoices = _searchedInvoice
        .where((invoice) =>
            ((invoice.invoiceStatus!.code.toLowerCase().contains("submit") ||
                    invoice.invoiceStatus!.name
                        .toLowerCase()
                        .contains("submit")) &&
                invoice.approver!.id == currentUser.id) ||
            (invoice.employee!.id == currentUser.id) ||
            (invoice.canPay == true) ||
            ((invoice.secondApprover != null &&
                    invoice.secondApprover == true) &&
                ((invoice.invoiceStatus!.code
                            .toLowerCase()
                            .contains("submit") ||
                        invoice.invoiceStatus!.name
                            .toLowerCase()
                            .contains("submit")) ||
                    (invoice.invoiceStatus!.code
                                .toLowerCase()
                                .contains("primar") ||
                            invoice.invoiceStatus!.name
                                .toLowerCase()
                                .contains("primar")) &&
                        (invoice.approver!.id == currentUser.id) ||
                    (invoice.employee!.id == currentUser.id))))
        .toList(growable: true);

    if ((invoices.isNotEmpty)) {
      return SearchTextInheritedWidget(
        searchText: _searchText,
        child: ListView.builder(
          itemCount: invoices.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return InvoiceItem(
              color: AppColors.white,
              padding: 10,
              invoice: invoices.elementAt(index),
              currencies: _currencies,
              showActions: true,
              showFinancialStatus: true,
            );
          },
        ),
      );
    } else {
      return Center(
        child: Text("Invoice with ${filterController.text} can't be found"),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_scrollListener);
    InvoiceApi.fetchAll().then((value) {
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
        InvoiceApi.fetchAll();
        _buildFilteredList();
        setState(() {});
      });
    }
  }

  _searchActivities(String value) {
    _buildFilteredList();
    _searchedInvoice.clear();
    _searchedInvoice.addAll(_filteredInvoice.where((smartInvoice) =>
        smartInvoice.number!.toLowerCase().contains(value.toLowerCase()) ||
        smartInvoice.caseFile!.fileName!
            .toLowerCase()
            .contains(value.toLowerCase()) ||
        smartInvoice.caseFile!.fileNumber!
            .toLowerCase()
            .contains(value.toLowerCase()) ||
        smartInvoice.invoiceStatus!.name
            .toLowerCase()
            .contains(value.toLowerCase()) ||
        smartInvoice.invoiceStatus!.code
            .toLowerCase()
            .contains(value.toLowerCase()) ||
        smartInvoice.approver!
            .getName()
            .toLowerCase()
            .contains(value.toLowerCase()) ||
        smartInvoice.amount!.toLowerCase().contains(value.toLowerCase()) ||
        smartInvoice.employee!
            .getName()
            .toLowerCase()
            .contains(value.toLowerCase()) ||
        smartInvoice.invoiceType!.name!
            .toLowerCase()
            .contains(value.toLowerCase())));
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
    await InvoiceApi.fetchAll().then((value) {
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

  _buildInvoiceForm() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => InvoiceForm(currencies: _currencies),
    );
  }

  _fetchMoreData() {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadMoreData = false;
      });
    }

    if (_isLoading && _invoicePage <= (pagesLength ?? _invoicePage + 1)) {
      // add ?? _invoicePage + 1
      _invoicePage++;
      InvoiceApi.fetchAll().then((value) {
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
