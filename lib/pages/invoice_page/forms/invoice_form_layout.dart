import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/bank/bank_model.dart';
import 'package:smart_case/database/client/client_model.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/database/invoice/invoice_type_model.dart';
import 'package:smart_case/pages/invoice_page/bloc/forms/invoice/invoice_form_bloc.dart';
import 'package:smart_case/pages/invoice_page/forms/invoice_items_form.dart';
import 'package:smart_case/pages/invoice_page/forms/loading_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_add_items_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_amounts_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_terms_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/invoice_view_layout.dart';
import 'package:smart_case/services/apis/smartcase_apis/bank_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/file_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_approver_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/utilities.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_dropdowns.dart';
import 'package:smart_case/widgets/custom_searchable_async_bottom_sheet_contents.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/form_title.dart';

class InvoiceFormLayout extends StatelessWidget {
  final _dateController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _clientAddressController = TextEditingController();
  final _clientController = TextEditingController();
  final _bankDetailsController = TextEditingController();
  final _invoiceTermsController = TextEditingController();
  final _scrollController = ScrollController();

  SmartFile? _file;
  SmartCurrency? _currency;
  SmartInvoiceType? _invoiceType;
  SmartBank? _bank;
  SmartEmployee? _approver;
  SmartInvoice? _invoice;

  @override
  Widget build(BuildContext context) {
    _invoiceTermsController.text =
        "1. Accounts carry interest at 6% effective one month form"
        " the date of receipt hereof R:6.\n2. Under VAT Statute"
        " 1996, 18% is payable on all fees.\n3. Accounts carry"
        " interest at 6% effective one month from the date date"
        " of receipt hereof R:6.";

    _reloadBanks();
    _reloadApprovers();

    return _buildBody();
  }

  Widget _buildBody() {
    return BlocListener<InvoiceFormBloc, InvoiceFormState>(
      listener: (context, state) {
        if (state.status == InvoiceFormStatus.error) {
          Navigator.pop(context);
          _onError();
        }
      },
      child: BlocBuilder<InvoiceFormBloc, InvoiceFormState>(
        builder: (context, state) {
          if (state.status == InvoiceFormStatus.initial) {
            context.read<InvoiceFormBloc>().add(PrepareInvoiceForm());
          }
          if (state.status == InvoiceFormStatus.loading) {
            return FormLoadingWidget();
          }
          if (state.status == InvoiceFormStatus.success) {
            _invoice = context.read<InvoiceFormBloc>().state.invoice;
            return _buildFormBody(context);
          }
          if (state.status == InvoiceFormStatus.success) {
            _currency = context
                .read<InvoiceFormBloc>()
                .state
                .currencies!
                .firstWhere((currency) => currency.code == 'UGX');
            return _buildFormBody(context);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildFormBody(BuildContext context) {
    bool isTitleElevated = false;
    bool isActivityLoading = false;

    final SingleValueDropDownController approversController =
        SingleValueDropDownController(
            data: _approver != null
                ? DropDownValueModel(value: _approver, name: _approver!.getName())
                : null);
    final SingleValueDropDownController invoiceTypeController =
        SingleValueDropDownController(
            data: _invoiceType != null
                ? DropDownValueModel(
                    value: _invoiceType, name: _invoiceType!.getName())
                : null);
    final SingleValueDropDownController bankController =
        SingleValueDropDownController(
            data: _bank != null
                ? DropDownValueModel(value: _bank, name: _bank!.getName())
                : null);

    if (context.read<InvoiceFormBloc>().state.invoice != null) {
      _dateController.text = (context.read<InvoiceFormBloc>().state.date != null)
          ? formatDateString(context.read<InvoiceFormBloc>().state.date)
          : "";
      _dueDateController.text =
          (context.read<InvoiceFormBloc>().state.dueDate != null)
              ? formatDateString(context.read<InvoiceFormBloc>().state.dueDate)
              : "";
      _file = context.read<InvoiceFormBloc>().state.file;
      _invoiceTermsController.text =
          context.read<InvoiceFormBloc>().state.paymentTerms ?? "";
      _bankDetailsController.text = context
          .read<InvoiceFormBloc>()
          .state
          .bank!
          .description!
          .replaceAll("<br />", "\n")
          .replaceAll("<p>", "")
          .replaceAll("</p>", "")
          .replaceAll("&amp;", "&")
          .replaceAll("&nbsp;", " ");
      invoiceFormItemList
          .addAll(context.read<InvoiceFormBloc>().state.invoiceItems ?? []);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          FormTitle(
            name: '${(_invoice == null) ? 'New' : 'Edit'} Invoice',
            onSave: () => _submitFormData(context),
            onCancel: () => _cancelFormData(context),
            isElevated: isTitleElevated,
            addButtonText: (_invoice == null) ? 'Add' : 'Update',
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (_scrollController.position.userScrollDirection ==
                      ScrollDirection.reverse) {
                    isTitleElevated = true;
                    context
                        .read<InvoiceFormBloc>()
                        .add(RefreshInvoiceForm(invoiceFormItemListItemList));
                  } else if (_scrollController.position.userScrollDirection ==
                      ScrollDirection.forward) {
                    if (_scrollController.position.pixels ==
                        _scrollController.position.maxScrollExtent) {
                      isTitleElevated = false;
                      context
                          .read<InvoiceFormBloc>()
                          .add(RefreshInvoiceForm(invoiceFormItemListItemList));
                    }
                  }
                  return true;
                },
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  children: [
                    LayoutBuilder(builder: (context, constraints) {
                      return Form(
                        child: Column(
                          children: [
                            SearchableDropDown<SmartInvoiceType>(
                              hintText: 'invoice type',
                              menuItems: preloadedInvoiceTypes.toSet().toList(),
                              onChanged: (value) {
                                _onTapSearchedInvoiceType(context,
                                    invoiceTypeController.dropDownValue?.value);
                              },
                              defaultValue: context
                                  .read<InvoiceFormBloc>()
                                  .state
                                  .invoiceType,
                              controller: invoiceTypeController,
                            ),
                            InvoiceDateTimeAccordion(
                              startName: 'Date',
                              endName: 'Due on',
                              startDateController: _dateController,
                              endDateController: _dueDateController,
                            ),
                            GestureDetector(
                              onTap: () => _showSearchFileBottomSheet(context),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(bottom: 10),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: SizedBox(
                                        width: constraints.maxWidth - 50,
                                        child: Text(
                                          _file?.fileName ?? 'Select file',
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: AppColors.darker,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.darker,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_file != null &&
                                _clientController.text.isNotEmpty)
                              Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: AppColors.white,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Client",
                                        style: TextStyle(
                                            color: AppColors.darker,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        _clientController.text,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (_file != null &&
                                _clientAddressController.text.isNotEmpty)
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Client address",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        CustomTextArea(
                                          minLines: 2,
                                          controller: _clientAddressController,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            CustomGenericDropdown<SmartCurrency>(
                              hintText: 'currency',
                              menuItems: context
                                  .read<InvoiceFormBloc>()
                                  .state
                                  .currencies!,
                              defaultValue: (context
                                      .read<InvoiceFormBloc>()
                                      .state
                                      .currencies!
                                      .isNotEmpty)
                                  ? (context
                                              .read<InvoiceFormBloc>()
                                              .state
                                              .currency !=
                                          null)
                                      ? context
                                          .read<InvoiceFormBloc>()
                                          .state
                                          .currencies!
                                          .firstWhere((cur) =>
                                              cur.code ==
                                              context
                                                  .read<InvoiceFormBloc>()
                                                  .state
                                                  .currency!
                                                  .code)
                                      : context
                                          .read<InvoiceFormBloc>()
                                          .state
                                          .currencies!
                                          .firstWhere((currency) =>
                                              currency.code == 'UGX')
                                  : null,
                              onChanged: (value) =>
                                  _onTapSearchedCurrency(context, value),
                            ),
                            InvoiceAddItemsWidget(
                                onTap: () => _showItemsDialog(context)),
                            InvoiceAmountsWidget(parentContext: context),
                            SearchableDropDown<SmartBank>(
                              hintText: 'bank',
                              menuItems: preloadedBanks.toSet().toList(),
                              onChanged: (value) {
                                _onTapSearchedBank(context,
                                    bankController.dropDownValue?.value);
                              },
                              defaultValue:
                                  context.read<InvoiceFormBloc>().state.bank,
                              controller: bankController,
                              clear: false,
                            ),
                            if (bankController.dropDownValue != null &&
                                _bankDetailsController.text.isNotEmpty)
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Bank details",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        CustomTextArea(
                                          readOnly: true,
                                          controller: _bankDetailsController,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            if (preloadedInvoiceApprovers.isNotEmpty)
                              SearchableDropDown<SmartEmployee>(
                                hintText: 'approver',
                                menuItems:
                                    preloadedInvoiceApprovers.toSet().toList(),
                                onChanged: (value) {
                                  _onTapSearchedApprover(context,
                                      approversController.dropDownValue?.value);
                                },
                                defaultValue: context
                                    .read<InvoiceFormBloc>()
                                    .state
                                    .supervisor,
                                controller: approversController,
                              ),
                            InvoiceTermsWidget(
                                controller: _invoiceTermsController),
                            const SizedBox(height: 20),
                            FilledButton(
                              onPressed: () {
                                try {
                                  var status = SmartInvoiceStatus(
                                      name: "Previewing invoice",
                                      code: "Previewing");
                                  var clientObj = SmartClient(
                                    name: _clientController.text,
                                    address: _clientAddressController.text,
                                  );
                                  var invoice = SmartInvoice(
                                    invoiceTypeId: _invoiceType!.id,
                                    invoiceType: _invoiceType,
                                    date: _dateController.text,
                                    dueDate: _dueDateController.text,
                                    invoiceStatus2: status,
                                    fileId: _file!.id,
                                    file: _file,
                                    clientId: _file!.clientId,
                                    bank: _bank,
                                    client: clientObj,
                                    clientAddress: _clientAddressController.text,
                                    currencyId: _currency!.id,
                                    currency: _currency,
                                    paymentTerms: _invoiceTermsController.text,
                                    bankId: _bank!.id,
                                    supervisorId: _approver!.id,
                                    approver: _approver,
                                    practiceAreasId: 1,
                                    invoiceItems: invoiceFormItemList,
                                  );

                                  showModalBottomSheet(
                                    enableDrag: true,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    context: context,
                                    builder: (context) =>
                                        InvoiceViewLayout(invoice: invoice),
                                  );
                                } catch (error) {
                                  Fluttertoast.showToast(
                                      msg: "Fill in all fields and try again",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: AppColors.red,
                                      textColor: AppColors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: Text("Preview Invoice"),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showSearchFileBottomSheet(BuildContext context) {
    List<SmartFile> searchedList = List.empty(growable: true);
    bool isLoading = false;
    return showModalBottomSheet(
        isScrollControlled: true,
        constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height * .8),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AsyncSearchableBottomSheetContents(
                hint: "Search file",
                list: searchedList,
                onTap: (value) {
                  setState(() {
                    _file = null;
                    _onTapSearchedFile(context, value!);
                  });
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      if (preloadedFiles.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(preloadedFiles.where((smartFile) =>
                            smartFile
                                .getName()
                                .toLowerCase()
                                .contains(value.toLowerCase())));
                      } else {
                        _reloadFiles();
                        isLoading = true;
                      }
                    }
                  });
                },
                isLoading: isLoading,
              );
            },
          );
        });
  }

  _reloadApprovers() async {
    await InvoiceApproverApi.fetchAll();
  }

  _reloadBanks() async {
    await BankApi.fetchAll();
  }

  _reloadFiles() async {
    await FileApi.fetchAll();
  }

  _onTapSearchedApprover(BuildContext context, SmartEmployee value) {
    _approver = value;
    context
        .read<InvoiceFormBloc>()
        .add(RefreshInvoiceForm(invoiceFormItemListItemList));
  }

  _onTapSearchedBank(BuildContext context, SmartBank value) {
    _bank = value;
    _bankDetailsController.text = _bank!.description!
        .replaceAll("<br />", "\n")
        .replaceAll("<p>", "")
        .replaceAll("</p>", "")
        .replaceAll("&amp;", "&")
        .replaceAll("&nbsp;", " ");
    context
        .read<InvoiceFormBloc>()
        .add(RefreshInvoiceForm(invoiceFormItemListItemList));
  }

  _onTapSearchedInvoiceType(BuildContext context, SmartInvoiceType value) {
    _invoiceType = value;
    context
        .read<InvoiceFormBloc>()
        .add(RefreshInvoiceForm(invoiceFormItemListItemList));
  }

  _onTapSearchedFile(BuildContext context, SmartFile value) {
    _file = value;
    _clientAddressController.text = _file!.address ?? "";
    _clientController.text = _file!.clientName ?? "";
    context
        .read<InvoiceFormBloc>()
        .add(RefreshInvoiceForm(invoiceFormItemListItemList));
  }

  _onTapSearchedCurrency(BuildContext context, SmartCurrency? value) {
    _currency = value;
    context
        .read<InvoiceFormBloc>()
        .add(RefreshInvoiceForm(invoiceFormItemListItemList));
  }

  _submitFormData(BuildContext context) {
    var invoice = SmartInvoice(
      invoiceTypeId: _invoiceType!.id,
      invoiceType: _invoiceType,
      date: _dateController.text,
      dueDate: _dueDateController.text,
      fileId: _file!.id,
      clientId: _file!.clientId,
      clientAddress: _clientAddressController.text,
      currencyId: _currency!.id,
      paymentTerms: _invoiceTermsController.text,
      bankId: _bank!.id,
      supervisorId: _approver!.id,
      invoiceItems: invoiceFormItemList,
    );
    InvoiceApi.post(
      invoice,
      onError: () {
        Fluttertoast.showToast(
            msg: "An error occurred",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: AppColors.red,
            textColor: AppColors.white,
            fontSize: 16.0);
      },
      onSuccess: () {
        Fluttertoast.showToast(
            msg: "Invoice added successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: AppColors.green,
            textColor: AppColors.white,
            fontSize: 16.0);
      },
    );

    Navigator.pop(context);
  }

  _cancelFormData(BuildContext context) {
    ttlSubAmount = null;
    ttlAmount = null;
    ttlTaxableAmount = null;
    invoiceFormItemList.clear();
    invoiceFormItemListItemList.clear();
    _scrollController.dispose();
    _dateController.dispose();
    _dueDateController.dispose();
    _invoiceTermsController.dispose();

    Navigator.pop(context);
  }

  _showItemsDialog(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height * .8),
      context: context,
      builder: (context) => InvoiceItemsForm(parentContext: context),
    );
  }

  _onError() async {
    Fluttertoast.showToast(
        msg: "An error occurred",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: AppColors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
