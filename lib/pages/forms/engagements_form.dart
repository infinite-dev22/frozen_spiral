import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/models/smart_client.dart';
import 'package:smart_case/models/smart_employee.dart';
import 'package:smart_case/models/smart_engagement.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/better_toast.dart';
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

  List<SmartClient> clients = List.empty(growable: true);
  List<SmartEngagementType> engagementTypes = List.empty(growable: true);

  SmartClient? client;
  SmartEngagementType? engagementType;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    final ScrollController scrollController = ScrollController();
    return Column(
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
                padding: const EdgeInsets.all(16),
                children: [
                  Form(
                    child: Column(
                      children: [
                        DateTimeAccordion2(
                            dateController: dateController,
                            startTimeController: startTimeController,
                            endTimeController: endTimeController),
                        Container(
                          height: 50,
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: _showSearchClientBottomSheet,
                            child: Text(
                              client?.getName() ?? 'Select client',
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: _showSearchEngagementTypeBottomSheet,
                            child: Text(
                              engagementType?.getName() ??
                                  'Select engagement type',
                            ),
                          ),
                        ),
                        SmartCaseTextField(
                            hint: 'Cost', controller: costController),
                        SmartCaseTextField(
                            hint: 'Cost description',
                            controller: costDescriptionController),
                        CustomTextArea(
                          key: globalKey,
                          hint: 'Description',
                          controller: descriptionController,
                          onTap: () {
                            Scrollable.ensureVisible(globalKey.currentContext!);
                          },
                        ),
                        const SizedBox(
                            height:
                                300 /* MediaQuery.of(context).viewInsets.bottom */),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
                    if (clients.isNotEmpty) {
                      isLoading = false;
                      searchedList.addAll(clients.where((smartClient) =>
                          smartClient
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
                    if (engagementTypes.isNotEmpty) {
                      isLoading = false;
                      searchedList.addAll(engagementTypes.where(
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
    Map engagementTypesMap = await SmartCaseApi.smartFetch(
        'api/admin/engagementypes', currentUser.token);
    List engagementTypeList = engagementTypesMap['engagementypes'];

    engagementTypes = engagementTypeList
        .map((doc) => SmartEngagementType.fromJson(doc))
        .toList();
    setState(() {});
  }

  _reloadClients() async {
    Map clientsMap =
        await SmartCaseApi.smartFetch('api/crm/clients', currentUser.token);
    List clientList = clientsMap['clients'];

    clients = clientList.map((doc) => SmartClient.fromJson(doc)).toList();
    setState(() {});
  }

  _submitForm() {
    SmartEngagement smartEngagement = SmartEngagement(
      cost: costController.text.trim(),
      costDescription: costDescriptionController.text.trim(),
      description: descriptionController.text.trim(),
      date: DateFormat('dd/MM/yyyy').parse(dateController.text.trim()),
      from: DateFormat('h:mm a').parse(startTimeController.text.trim()),
      to: DateFormat('h:mm a').parse(endTimeController.text.trim()),
      engagementTypeId: engagementType!.id,
      clientId: client!.id,
      isNextEngagement: 0,
      notifyOn: DateFormat('dd/MM/yyyy').parse(dateController.text.trim()),
      notifyOnAt: DateFormat('h:mm a').parse(startTimeController.text.trim()),
      notifyWith: [SmartEmployee(id: 1)],
      doneBy: [SmartEmployee(id: 1)],
    );

    (widget.engagement == null)
        ? SmartCaseApi.smartPost('api/crm/engagements', currentUser.token,
            smartEngagement.toCreateJson(), onError: () {
            const BetterErrorToast(text: "An error occurred");
          }, onSuccess: () {
            const BetterSuccessToast(text: "Engagement added successfully");
          })
        : SmartCaseApi.smartPut('api/crm/engagements/${widget.engagement!.id}',
            currentUser.token, smartEngagement.toCreateJson(), onError: () {
            const BetterErrorToast(text: "An error occurred");
          }, onSuccess: () {
            const BetterSuccessToast(text: "Engagement updated successfully");
          });

    Navigator.pop(context);
  }
}
