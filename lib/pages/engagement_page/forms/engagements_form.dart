import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/client/client_model.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/engagement/engagement_model.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/client_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/engagement_type_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_searchable_async_bottom_sheet_contents.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/form_title.dart';

class EngagementForm extends StatefulWidget {
  final SmartEngagement? engagement;

  const EngagementForm({super.key, this.engagement});

  @override
  State<EngagementForm> createState() => _EngagementFormState();
}

class _EngagementFormState extends State<EngagementForm> {
  final globalKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  bool isTitleElevated = false;

  TextEditingController costController = TextEditingController();
  TextEditingController costDescriptionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  final ValueNotifier<SmartClient?> clientSelectedValue =
      ValueNotifier<SmartClient?>(null);
  final ValueNotifier<SmartEngagementType?> fileSelectedValue =
      ValueNotifier<SmartEngagementType?>(null);

  SmartClient? client;
  SmartEngagementType? engagementType;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    final ScrollController scrollController = ScrollController();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          FormTitle(
            name: '${(widget.engagement == null) ? 'New' : 'Edit'} Engagement',
            addButtonText: (widget.engagement == null) ? 'Add' : 'Update',
            isElevated: isTitleElevated,
            onSave: () => _submitForm(),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollController.position.userScrollDirection ==
                      ScrollDirection.reverse) {
                    setState(() {
                      isTitleElevated = true;
                    });
                  } else if (scrollController.position.userScrollDirection ==
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
                        key: formKey,
                        child: Column(
                          children: [
                            EngagementDateTimeAccordion(
                                dateController: dateController,
                                startTimeController: startTimeController,
                                endTimeController: endTimeController),
                            GestureDetector(
                              onTap: _showSearchClientBottomSheet,
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: constraints.maxWidth - 50,
                                        child: Text(
                                          client?.getName() ?? 'Select client',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: AppColors.darker,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
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
                            ),
                            GestureDetector(
                              onTap: _showSearchEngagementTypeBottomSheet,
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: constraints.maxWidth - 50,
                                        child: Text(
                                          engagementType?.getName() ??
                                              'Select engagement type',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: AppColors.darker,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
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
                            ),
                            SmartCaseNumberField(
                              hint: 'Cost',
                              controller: costController,
                              maxLength: 14,
                            ),
                            CustomTextArea(
                              hint: 'Cost description',
                              controller: costDescriptionController,
                              minLines: 1,
                              maxLines: 4,
                              maxLength: 255,
                              onTap: () {
                                Scrollable.ensureVisible(
                                    globalKey.currentContext!);
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextArea(
                              key: globalKey,
                              hint: 'Description',
                              controller: descriptionController,
                              onTap: () {
                                Scrollable.ensureVisible(
                                    globalKey.currentContext!);
                              },
                            ),
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

  _showSearchClientBottomSheet() {
    List<SmartClient> searchedList = List.empty(growable: true);
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
                hint: "Search clients",
                list: searchedList,
                onTap: (value) {
                  client = null;
                  _onTapSearchedClient(value!);
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  searchedList.clear();
                  if (value.length > 2) {
                    if (preloadedClients.isNotEmpty) {
                      isLoading = false;
                      searchedList.addAll(preloadedClients.where(
                          (smartClient) => smartClient
                              .getName()
                              .toLowerCase()
                              .contains(value.toLowerCase())));
                      setState(() {});
                    } else {
                      _reloadClients();
                      isLoading = true;
                      setState(() {});
                    }
                  }
                },
                isLoading: isLoading,
              );
            },
          );
        });
  }

  _showSearchEngagementTypeBottomSheet() {
    List<SmartEngagementType> searchedList = List.empty(growable: true);
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
                hint: "Search engagement types",
                list: searchedList,
                onTap: (value) {
                  Navigator.pop(context);
                  _onTapSearchedEngagementType(value!);
                },
                onSearch: (value) {
                  searchedList.clear();
                  if (value.length > 2) {
                    if (preloadedEngagementTypes.isNotEmpty) {
                      isLoading = false;
                      searchedList.addAll(preloadedEngagementTypes.where(
                          (engagementType) => engagementType.name!
                              .toLowerCase()
                              .contains(value.toLowerCase())));
                      setState(() {});
                    } else {
                      _reloadEngagementTypes();
                      isLoading = true;
                      setState(() {});
                    }
                  }
                },
                isLoading: isLoading,
              );
            },
          );
        });
  }

  _onTapSearchedEngagementType(SmartEngagementType value) {
    setState(() {
      engagementType = value;
    });
  }

  _onTapSearchedClient(SmartClient value) {
    setState(() {
      client = value;
    });
  }

  _reloadEngagementTypes() async {
    EngagementTypeApi.fetchAll();
    setState(() {});
  }

  _reloadClients() async {
    await ClientApi.fetchAll();
  }

  _submitForm() {
    if (formKey.currentState!.validate()) {
      SmartEngagement smartEngagement = SmartEngagement(
        cost: costController.text.trim(),
        costDescription: costDescriptionController.text.trim(),
        description: descriptionController.text.trim(),
        date: DateFormat('dd/MM/yyyy').parse(dateController.text.trim()),
        from: DateFormat('hh:mm a').parse(startTimeController.text.trim()),
        to: DateFormat('hh:mm a').parse(endTimeController.text.trim()),
        engagementTypeId: engagementType!.id,
        clientId: client!.id,
        isNextEngagement: 0,
        notifyOn: DateFormat('dd/MM/yyyy').parse(dateController.text.trim()),
        notifyOnAt:
            DateFormat('hh:mm a').parse(startTimeController.text.trim()),
        notifyWith: [SmartEmployee(id: 1)],
        doneBy: [SmartEmployee(id: 1)],
      );

      (widget.engagement == null)
          ? SmartCaseApi.smartPost('api/crm/engagements', currentUser.token,
              smartEngagement.toCreateJson(), onError: () {
              Fluttertoast.showToast(
                  msg: "An error occurred",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 5,
                  backgroundColor: AppColors.red,
                  textColor: AppColors.white,
                  fontSize: 16.0);
            }, onSuccess: () {
              Fluttertoast.showToast(
                  msg: "Engagement added successfully",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 5,
                  backgroundColor: AppColors.green,
                  textColor: AppColors.white,
                  fontSize: 16.0);
            })
          : SmartCaseApi.smartPut(
              'api/crm/engagements/${widget.engagement!.id}',
              currentUser.token,
              smartEngagement.toCreateJson(), onError: () {
              Fluttertoast.showToast(
                  msg: "An error occurred",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 5,
                  backgroundColor: AppColors.red,
                  textColor: AppColors.white,
                  fontSize: 16.0);
            }, onSuccess: () {
              Fluttertoast.showToast(
                  msg: "Engagement updated successfully",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 5,
                  backgroundColor: AppColors.green,
                  textColor: AppColors.white,
                  fontSize: 16.0);
            });

      Navigator.pop(context);
    }
  }
}
