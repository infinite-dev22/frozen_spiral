import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/models/smart_task.dart';

import '../models/smart_client.dart';
import '../services/apis/smartcase_api.dart';
import '../theme/color.dart';
import '../util/smart_case_init.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/task_widget/task_item.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late SmartClient client;
  TextEditingController filterController = TextEditingController();

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
      body: _buildBody(),
    );
  }

  _buildBody() {
    return (kDebugMode)
        ? (filteredTasks.isEmpty)
            ? _buildNonSearchedBody()
            : _buildSearchedBody()
        : const Center(
            child: Text(
              'Coming soon...',
              style: TextStyle(color: AppColors.inActiveColor),
            ),
          );
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
        : const Center(
            child: CircularProgressIndicator(),
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
            child: CircularProgressIndicator(),
          );
  }

  Future<void> _setUpData() async {
    Map response =
        await SmartCaseApi.smartFetch('api/tasks', currentUser.token);
    List tasksList = response["search"]["tasks"];
    tasks = tasksList.map((doc) => SmartTask.fromJson(doc)).toList();

    filterController.text == 'Name';
    setState(() {});
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

  @override
  void initState() {
    _setUpData();

    super.initState();
  }
}
