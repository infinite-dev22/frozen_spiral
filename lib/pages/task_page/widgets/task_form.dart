import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/task/task_model.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/file_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_searchable_async_bottom_sheet_contents.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/form_title.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key, this.task});

  final SmartTask? task;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final formKey = GlobalKey<FormState>();

  bool isTitleElevated = false;
  bool isAssigneeLoading = false;

  SmartFile? file;
  SmartEmployee? assignee;
  int? assigneeId;

  List<SmartEmployee> assignees = List.empty(growable: true);
  List<SmartEmployee> selectedAssignees = List.empty(growable: true);
  List<int> selectedAssigneesIds = List.empty(growable: true);
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    final ScrollController scrollController = ScrollController();

    return Column(
      children: [
        FormTitle(
          name: '${(widget.task == null) ? "New" : "Edit"} Task',
          addButtonText: (widget.task == null) ? 'Add' : 'Update',
          onSave: () => _submitForm(),
          isElevated: isTitleElevated,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                            SmartCaseTextField(
                              hint: 'Name',
                              controller: nameController,
                              maxLength: 50,
                              minLines: 1,
                              maxLines: 1,
                            ),
                            GestureDetector(
                              onTap: _showSearchFileBottomSheet,
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: SizedBox(
                                        width: constraints.maxWidth - 50,
                                        child: Text(
                                          file?.fileName ?? 'Select file',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
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
                            _chipDisplay(constraints),
                            TaskDateTimeAccordion(
                                dateController: dueDateController,
                                startTimeController: startTimeController,
                                endTimeController: endTimeController),
                            CustomTextArea(
                                hint: 'Description',
                                controller: descriptionController),
                          ],
                        ),
                      );
                    }),
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  void _showMultiSelect() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return MultiSelectBottomSheet<SmartEmployee>(
          searchable: true,
          searchHint: "Search assignees",
          title: const Text(
            "Assignees",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          items: assignees
              .map((assignee) => MultiSelectItem(assignee, assignee.getName()))
              .toList(),
          initialValue: selectedAssignees,
          onConfirm: (employees) {
            selectedAssignees.clear();
            selectedAssigneesIds.clear();
            for (var employee in employees) {
              selectedAssignees.add(employee);
              selectedAssigneesIds.add(employee.getId());
            }
            setState(() {});
          },
          maxChildSize: 0.8,
        );
      },
    );
  }

  Widget _chipDisplay(BoxConstraints constraints) {
    return GestureDetector(
      onTap: () => _showMultiSelect(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              children: List.generate(
                  selectedAssignees.length,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SelectTag(
                            label: selectedAssignees.elementAt(index).getName(),
                            onDeleted: (value) {
                              selectedAssignees.removeAt(index);
                              selectedAssigneesIds.removeAt(index);
                              setState(() {});
                            },
                            index: index),
                      )),
            ),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: SizedBox(
                      width: constraints.maxWidth - 50,
                      child: const Text(
                        'Select assignees',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
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
          ],
        ),
      ),
    );
  }

  _showSearchFileBottomSheet() {
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
                  file = null;
                  _onTapSearchedFile(value!);
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  searchedList.clear();
                  if (value.length > 2) {
                    if (preloadedFiles.isNotEmpty) {
                      isLoading = false;
                      searchedList.addAll(preloadedFiles.where((smartFile) =>
                          smartFile
                              .getName()
                              .toLowerCase()
                              .contains(value.toLowerCase())));
                      setState(() {});
                    } else {
                      _loadFiles();
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

  _loadFiles() async {
    await FileApi.fetchAll();
  }

  _loadAssignees() async {
    Map usersMap = await SmartCaseApi.smartFetch(
        'api/hr/employees/requisitionApprovers', currentUser.token);

    List users = usersMap['search']['employees'];

    assignees = users.map((doc) => SmartEmployee.fromJson(doc)).toList();
  }

  _onTapSearchedFile(SmartFile value) {
    setState(() {
      file = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _fillInFormDataForEdit();
    _loadFiles();
    _loadAssignees();
  }

  _fillInFormDataForEdit() {
    if (widget.task != null) {
      nameController.text = widget.task!.taskName!;
      file = widget.task?.caseFile;
      selectedAssignees = widget.task!.assignees!;

      descriptionController.text = widget.task!.description!;
      dueDateController.text = widget.task!.dueAt != null
          ? DateFormat('dd/MM/yyyy').format(widget.task!.dueAt!)
          : '';
      // To Do: lines below will be uncommented when activity class is re-written.
      startTimeController.text = widget.task!.endDate != null
          ? DateFormat.jm().format(widget.task!.endDate!)
          : "";
      endTimeController.text = widget.task!.endDate != null
          ? DateFormat.jm().format(widget.task!.endDate!)
          : "";
    }
  }

  _submitForm() {
    if (formKey.currentState!.validate()) {
      SmartTask smartTask = SmartTask(
        taskName: nameController.text.trim(),
        description: descriptionController.text.trim(),
        matter: 1,
        caseStatus: 'TASK',
        priority: 'High',
        dueAt: DateFormat('dd/MM/yyyy').parse(dueDateController.text.trim()),
        estimatedTime: startTimeController.text.trim(),
        // assignees: [assignee!],
        // assigneeIds: [assigneeId!],
        assigneeIds: selectedAssigneesIds,
      );

      jsonEncode(smartTask.toCreateJson());

      (widget.task == null)
          ? SmartCaseApi.smartPost(
              'api/tasks', currentUser.token, smartTask.toCreateJson(),
              onError: () {
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
                  msg: "Task added successfully",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 5,
                  backgroundColor: AppColors.green,
                  textColor: AppColors.white,
                  fontSize: 16.0);
            })
          : SmartCaseApi.smartPut('api/tasks/${widget.task!.id}',
              currentUser.token, smartTask.toCreateJson(), onError: () {
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
                  msg: "Task updated successfully",
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

  Future<List<SmartEmployee>> searchFunction(query) async {
    return assignees.where((element) {
      return element.getName().toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

class SelectTag extends StatelessWidget {
  const SelectTag({
    super.key,
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;
  final Color darkAlias6 = const Color.fromRGBO(36, 37, 51, 0.06);

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: darkAlias6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
