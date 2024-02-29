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
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_dropdowns.dart';
import 'package:smart_case/widgets/custom_searchable_async_bottom_sheet_contents.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/form_title.dart';

class InvoiceFormLayout extends StatefulWidget {
  final SmartInvoice? invoice;

  const InvoiceFormLayout({
    super.key,
    this.invoice,
  });

  @override
  State<InvoiceFormLayout> createState() => _InvoiceFormLayoutState();
}

class _InvoiceFormLayoutState extends State<InvoiceFormLayout> {
  SmartFile? file;
  SmartCurrency? currency;
  SmartInvoiceType? invoiceType;
  SmartBank? bank;
  SmartEmployee? approver;

  final globalKey = GlobalKey();
  bool isTitleElevated = false;
  bool isActivityLoading = false;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController clientAddressController = TextEditingController();
  final TextEditingController clientController = TextEditingController();
  final TextEditingController bankDetailsController = TextEditingController();
  final TextEditingController invoiceTermsController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    final SingleValueDropDownController approversController =
        SingleValueDropDownController(
            data: approver != null
                ? DropDownValueModel(value: approver, name: approver!.getName())
                : null);
    final SingleValueDropDownController invoiceTypeController =
        SingleValueDropDownController(
            data: invoiceType != null
                ? DropDownValueModel(
                    value: invoiceType, name: invoiceType!.getName())
                : null);
    final SingleValueDropDownController bankController =
        SingleValueDropDownController(
            data: bank != null
                ? DropDownValueModel(value: bank, name: bank!.getName())
                : null);

    return BlocListener<InvoiceFormBloc, InvoiceFormState>(
      listener: (context, state) {
        if (state.status == InvoiceFormStatus.error) {
          Navigator.pop(context);
          _onError();
        }
      },
      child: BlocBuilder<InvoiceFormBloc, InvoiceFormState>(
        builder: (cntxt, state) {
          if (state.status == InvoiceFormStatus.initial) {
            cntxt.read<InvoiceFormBloc>().add(PrepareInvoiceForm());
          }
          if (state.status == InvoiceFormStatus.loading) {
            return FormLoadingWidget();
          }
          if (state.status == InvoiceFormStatus.success) {
            currency = cntxt
                .read<InvoiceFormBloc>()
                .state
                .currencies!
                .firstWhere((currency) => currency.code == 'UGX');
            return Padding(
              padding: const EdgeInsets.only(bottom: 20)
                  .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  FormTitle(
                    name:
                        '${(widget.invoice == null) ? 'New' : 'Edit'} Invoice',
                    onSave: () => _submitFormData(),
                    onCancel: () => _cancelFormData(),
                    isElevated: isTitleElevated,
                    addButtonText: (widget.invoice == null) ? 'Add' : 'Update',
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollController.position.userScrollDirection ==
                              ScrollDirection.reverse) {
                            setState(() {
                              isTitleElevated = true;
                            });
                          } else if (scrollController
                                  .position.userScrollDirection ==
                              ScrollDirection.forward) {
                            if (scrollController.position.pixels ==
                                scrollController.position.maxScrollExtent) {
                              setState(() {
                                isTitleElevated = false;
                              });
                            }
                          }
                          return true;
                        },
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(8),
                          children: [
                            LayoutBuilder(builder: (context, constraints) {
                              return Form(
                                child: Column(
                                  children: [
                                    SearchableDropDown<SmartInvoiceType>(
                                      hintText: 'invoice type',
                                      menuItems: preloadedInvoiceTypes
                                          .toSet()
                                          .toList(),
                                      onChanged: (value) {
                                        _onTapSearchedInvoiceType(
                                            cntxt,
                                            invoiceTypeController
                                                .dropDownValue?.value);
                                      },
                                      defaultValue: invoiceType,
                                      controller: invoiceTypeController,
                                    ),
                                    InvoiceDateTimeAccordion(
                                      startName: 'Date',
                                      endName: 'Due on',
                                      startDateController: dateController,
                                      endDateController: dueDateController,
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          _showSearchFileBottomSheet(cntxt),
                                      child: Container(
                                        height: 50,
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(5),
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: SizedBox(
                                                width:
                                                    constraints.maxWidth - 50,
                                                child: Text(
                                                  file?.fileName ??
                                                      'Select file',
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: AppColors.darker,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
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
                                    if (file != null &&
                                        clientController.text.isNotEmpty)
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                clientController.text,
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (file != null &&
                                        clientAddressController.text.isNotEmpty)
                                      Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("Client address",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                CustomTextArea(
                                                  minLines: 2,
                                                  controller:
                                                      clientAddressController,
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    CustomGenericDropdown<SmartCurrency>(
                                      hintText: 'currency',
                                      menuItems: cntxt
                                          .read<InvoiceFormBloc>()
                                          .state
                                          .currencies!,
                                      defaultValue: (cntxt
                                              .read<InvoiceFormBloc>()
                                              .state
                                              .currencies!
                                              .isNotEmpty)
                                          ? (currency != null)
                                              ? cntxt
                                                  .read<InvoiceFormBloc>()
                                                  .state
                                                  .currencies!
                                                  .firstWhere((cur) =>
                                                      cur.code ==
                                                      currency!.code)
                                              : cntxt
                                                  .read<InvoiceFormBloc>()
                                                  .state
                                                  .currencies!
                                                  .firstWhere((currency) =>
                                                      currency.code == 'UGX')
                                          : null,
                                      onChanged: (value) =>
                                          _onTapSearchedCurrency(cntxt, value),
                                    ),
                                    InvoiceAddItemsWidget(
                                        onTap: () => _showItemsDialog(cntxt)),
                                    InvoiceAmountsWidget(parentContext: cntxt),
                                    SearchableDropDown<SmartBank>(
                                      hintText: 'bank',
                                      menuItems:
                                          preloadedBanks.toSet().toList(),
                                      onChanged: (value) {
                                        _onTapSearchedBank(
                                            cntxt,
                                            bankController
                                                .dropDownValue?.value);
                                      },
                                      defaultValue: bank,
                                      controller: bankController,
                                      clear: false,
                                    ),
                                    if (bankController.dropDownValue != null &&
                                        bankDetailsController.text.isNotEmpty)
                                      Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text("Bank details",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                CustomTextArea(
                                                  readOnly: true,
                                                  controller:
                                                      bankDetailsController,
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
                                        menuItems: preloadedInvoiceApprovers
                                            .toSet()
                                            .toList(),
                                        onChanged: (value) {
                                          _onTapSearchedApprover(
                                              cntxt,
                                              approversController
                                                  .dropDownValue?.value);
                                        },
                                        defaultValue: approver,
                                        controller: approversController,
                                      ),
                                    InvoiceTermsWidget(
                                        controller: invoiceTermsController),
                                    const SizedBox(height: 20),
                                    FilledButton(
                                      onPressed: () {
                                        try {
                                          var status = SmartInvoiceStatus(
                                              name: "Previewing invoice",
                                              code: "Previewing");
                                          var clientObj = SmartClient(
                                            name: clientController.text,
                                            address:
                                                clientAddressController.text,
                                          );
                                          var invoice = SmartInvoice(
                                            invoiceTypeId: invoiceType!.id,
                                            invoiceType: invoiceType,
                                            date: dateController.text,
                                            dueDate: dueDateController.text,
                                            invoiceStatus2: status,
                                            fileId: file!.id,
                                            file: file,
                                            clientId: file!.clientId,
                                            bank: bank,
                                            client: clientObj,
                                            clientAddress:
                                                clientAddressController.text,
                                            currencyId: currency!.id,
                                            currency: currency,
                                            paymentTerms:
                                                invoiceTermsController.text,
                                            bankId: bank!.id,
                                            supervisorId: approver!.id,
                                            approver: approver,
                                            practiceAreasId: 1,
                                            invoiceItems: invoiceFormItemList,
                                          );

                                          showModalBottomSheet(
                                            enableDrag: true,
                                            isScrollControlled: true,
                                            useSafeArea: true,
                                            context: context,
                                            builder: (context) =>
                                                InvoiceViewLayout(
                                                    invoice: invoice),
                                          );
                                        } catch (error) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Fill in all fields and try again",
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
          return Container();
        },
      ),
    );
  }

  _showSearchFileBottomSheet(BuildContext cntxt) {
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
                    file = null;
                    _onTapSearchedFile(cntxt, value!);
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

  _onTapSearchedApprover(BuildContext cntxt, SmartEmployee value) {
    approver = value;
    cntxt
        .read<InvoiceFormBloc>()
        .add(RefreshInvoiceForm(invoiceFormItemListItemList));
  }

  _onTapSearchedBank(BuildContext cntxt, SmartBank value) {
    bank = value;
    bankDetailsController.text = bank!.description!
        .replaceAll("<br />", "\n")
        .replaceAll("<p>", "")
        .replaceAll("</p>", "")
        .replaceAll("&amp;", "&")
        .replaceAll("&nbsp;", " ");
    cntxt
        .read<InvoiceFormBloc>()
        .add(RefreshInvoiceForm(invoiceFormItemListItemList));
  }

  _onTapSearchedInvoiceType(BuildContext context, SmartInvoiceType value) {
    invoiceType = value;
    context
        .read<InvoiceFormBloc>()
        .add(RefreshInvoiceForm(invoiceFormItemListItemList));
  }

  _onTapSearchedFile(BuildContext cntxt, SmartFile value) {
    file = value;
    clientAddressController.text = file!.address ?? "";
    clientController.text = file!.clientName ?? "";
    cntxt
        .read<InvoiceFormBloc>()
        .add(RefreshInvoiceForm(invoiceFormItemListItemList));
  }

  _fillDataForUpdate() {
    if (widget.invoice != null) {
      file = widget.invoice!.file!;
    }
  }

  _onTapSearchedCurrency(BuildContext cntxt, SmartCurrency? value) {
    setState(() {
      currency = value;
      cntxt
          .read<InvoiceFormBloc>()
          .add(RefreshInvoiceForm(invoiceFormItemListItemList));
    });
  }

  _submitFormData() {
    var invoice = SmartInvoice(
      invoiceTypeId: invoiceType!.id,
      invoiceType: invoiceType,
      date: dateController.text,
      dueDate: dueDateController.text,
      fileId: file!.id,
      clientId: file!.clientId,
      clientAddress: clientAddressController.text,
      currencyId: currency!.id,
      paymentTerms: invoiceTermsController.text,
      bankId: bank!.id,
      supervisorId: approver!.id,
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

  _cancelFormData() {
    Navigator.pop(context);
  }

  _showItemsDialog(BuildContext cntxt) {
    return showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height * .8),
      context: context,
      builder: (context) => InvoiceItemsForm(parentContext: cntxt),
    );
  }

  @override
  void initState() {
    super.initState();
    invoiceTermsController.text =
        "1. Accounts carry interest at 6% effective one month form"
        " the date of receipt hereof R:6.\n2. Under VAT Statute"
        " 1996, 18% is payable on all fees.\n3. Accounts carry"
        " interest at 6% effective one month from the date date"
        " of receipt hereof R:6.";

    _reloadBanks();
    _reloadApprovers();
    _fillDataForUpdate();
  }

  @override
  void dispose() {
    super.dispose();
    ttlSubAmount = null;
    ttlAmount = null;
    ttlTaxableAmount = null;
    invoiceFormItemList.clear();
    invoiceFormItemListItemList.clear();
    scrollController.dispose();
    dateController.dispose();
    dueDateController.dispose();
    invoiceTermsController.dispose();
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
