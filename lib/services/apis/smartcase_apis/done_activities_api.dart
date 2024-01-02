import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/reports/done_activities_repo.dart';
import 'package:smart_case/database/reports/models/done_activities_report.dart';

class DoneActivitiesApi {
  static Future<List<SmartDoneActivityReport>> fetchAll() async {
    DoneActivitiesRepo causeListRepo = DoneActivitiesRepo();
    List<SmartDoneActivityReport> causeLists = List.empty(growable: true);

    var response = await causeListRepo.fetchAll();

    List causeListsMap = response['search']['doneActivities'];
    print("Dope List: ${causeListsMap.length}");

    if (causeListsMap.isNotEmpty) {
      causeLists = causeListsMap
          .map(
            (causeList) => SmartDoneActivityReport.fromJson(causeList),
          )
          .toList();
    }

    preloadedDoneActivities.clear();
    preloadedDoneActivities = causeLists;
    return preloadedDoneActivities;
  }
}
