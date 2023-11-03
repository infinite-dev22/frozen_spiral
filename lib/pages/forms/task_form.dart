import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smart_case/models/smart_employee.dart';
import 'package:smart_case/models/smart_task.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

import '../../models/smart_file.dart';
import '../../services/apis/smartcase_api.dart';
import '../../theme/color.dart';
import '../../util/smart_case_init.dart';
import '../../widgets/custom_accordion.dart';
import '../../widgets/custom_searchable_async_bottom_sheet_contents.dart';
import '../../widgets/custom_searchable_async_file_bottom_sheet_contents.dart';
import '../../widgets/form_title.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key, this.onSave, this.task});

  final SmartTask? task;
  final Function()? onSave;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  bool isTitleElevated = false;
  bool isAssigneeLoading = false;

  SmartFile? file;
  SmartEmployee? assignee;

  List<SmartFile> files = List.empty(growable: true);
  List<SmartEmployee> assignees = List.empty(growable: true);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
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
          onSave: () {},
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
                padding: const EdgeInsets.all(16),
                children: [
                  SmartCaseTextField(hint: 'Name', controller: nameController),
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
                      onPressed: _showSearchFileBottomSheet,
                      child: Text(
                        widget.task?.caseFile?.fileName ?? 'Select file',
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
                      onPressed: _showSearchAssigneeBottomSheet,
                      child: Text(
                        widget.task?.assignees?[1].getName() ??
                            'Select assignee',
                      ),
                    ),
                  ),
                  DateTimeAccordion2(
                      dateController: dateController,
                      startTimeController: startTimeController,
                      endTimeController: endTimeController),
                  CustomTextArea(
                      hint: 'Description', controller: descriptionController),
                ],
              ),
            ),
          ),
        ),
      ],
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
              return AsyncSearchableSmartFileBottomSheetContents(
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
                    if (files.isNotEmpty) {
                      isLoading = false;
                      searchedList.addAll(files.where((smartFile) => smartFile
                          .fileName!
                          .toLowerCase()
                          .contains(value.toLowerCase())));
                      setState(() {});
                    } else {
                      _reloadFiles();
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

  _showSearchAssigneeBottomSheet() {
    List<SmartEmployee> searchedList = List.empty(growable: true);
    return showModalBottomSheet(
        isScrollControlled: true,
        constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height * .8),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AsyncSearchableBottomSheetContents(
                hint: "Search assignee",
                list: searchedList,
                onTap: (value) {
                  file = null;
                  _onTapSearchedAssignee(value!);
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  searchedList.clear();
                  if (value.length > 2) {
                    if (assignees.isNotEmpty) {
                      isAssigneeLoading = false;
                      searchedList.addAll(assignees.where((smartEmployee) =>
                          smartEmployee
                              .getName()
                              .toLowerCase()
                              .contains(value.toLowerCase())));
                      setState(() {});
                    } else {
                      _reloadFiles();
                      isAssigneeLoading = true;
                    }
                  }
                },
                isLoading: isAssigneeLoading,
              );
            },
          );
        });
  }

  _reloadFiles() async {
    files = await SmartCaseApi.fetchAllFiles(currentUser.token);
    setState(() {});
  }

  _loadFiles() async {
    files = await SmartCaseApi.fetchAllFiles(currentUser.token);
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

  _onTapSearchedAssignee(SmartEmployee value) {
    setState(() {
      assignee = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _loadFiles();
    _loadAssignees();
  }
}
