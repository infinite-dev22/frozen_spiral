import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/database/client/client_model.dart';
import 'package:smart_case/database/task/task_model.dart';
import 'package:smart_case/pages/task_page/widgets/task_form.dart';
import 'package:smart_case/pages/task_page/widgets/task_item.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late SmartClient client;
  TextEditingController filterController = TextEditingController();
  bool isLoading = true;

  List<SmartTask> tasks = List.empty(growable: true);
  List<SmartTask> filteredTasks = List.empty(growable: true);
  final List<String>? filters = [
    "Name",
    "File",
    "Priority",
    "Assigner",
    "Status",
  ];

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
          search: 'tasks',
          filterController: filterController,
          filters: filters,
          onChanged: _searchFiles,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buildTaskForm,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return (filteredTasks.isEmpty)
        ? _buildNonSearchedBody()
        : _buildSearchedBody();
  }

  _buildNonSearchedBody() {
    return (tasks.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              top: 16,
              right: 10,
              bottom: 80,
            ),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              // getUser(tasks[index].caseFile!.clientId!);
              return TaskItem(task: tasks[index]);
            })
        : Center(
            child: (isLoading)
                ? const CupertinoActivityIndicator(radius: 20)
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You have no tasks currently",
                        style: TextStyle(
                            color: AppColors.inActiveColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Tasks appear here",
                        style: TextStyle(
                          color: AppColors.inActiveColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          );
  }

  _buildSearchedBody() {
    return (filteredTasks.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              top: 16,
              right: 10,
              bottom: 80,
            ),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              // getUser(filteredTasks[index].caseFile!.clientId!);
              return TaskItem(task: filteredTasks[index]);
            })
        : const Center(
            child: Text('No result found'),
          );
  }

  Future<void> _setUpData() async {
    Map response = await SmartCaseApi.smartFetch('api/tasks', currentUser.token,
        onSuccess: () => {
              setState(() {
                isLoading = false;
              })
            });
    List tasksList = response["search"]["tasks"];
    tasks = tasksList.map((doc) => SmartTask.fromJson(doc)).toList();

    filterController.text == 'Name';
    if (mounted) setState(() {});
  }

  Future<void> getUser(int userId) async {
    Map response = await SmartCaseApi.smartFetch(
        'api/crm/clients/$userId', currentUser.token);
    client = SmartClient.fromJson(response["client"]);
    setState(() {});
  }

  _searchFiles(String value) {
    filteredTasks.clear();
    if (filterController.text == 'File') {
      filteredTasks.addAll(tasks.where((smartTask) => smartTask.caseFile!
          .getName()
          .toLowerCase()
          .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Priority') {
      filteredTasks.addAll(tasks.where((smartTask) =>
          smartTask.priority!.toLowerCase().contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Assigner') {
      filteredTasks.addAll(tasks.where((smartTask) =>
          smartTask.assigner!.getName().contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'Status (Task)') {
      filteredTasks.addAll(tasks.where((smartTask) =>
          smartTask.caseStatus!.toLowerCase().contains(value.toLowerCase())));
      setState(() {});
    } else {
      filteredTasks.addAll(tasks.where((smartTask) =>
          smartTask.getName().toLowerCase().contains(value.toLowerCase())));
      setState(() {});
    }
  }

  _buildTaskForm() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => const TaskForm(),
    );
  }

  @override
  void initState() {
    _setUpData();

    super.initState();
  }
}
