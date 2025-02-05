import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/reports/cause_list_repo.dart';
import 'package:smart_case/database/reports/models/cause_list_report.dart';

class CauseListApi {
  static Future<List<SmartCauseListReport>> fetchAll() async {
    CauseListRepo causeListRepo = CauseListRepo();
    List<SmartCauseListReport> causeLists = List.empty(growable: true);

    var response = await causeListRepo.fetchAll();

    List causeListsMap = response['search']['nextActivities'];

    if (causeListsMap.isNotEmpty) {
      causeLists = causeListsMap
          .map(
            (causeList) => SmartCauseListReport.fromJson(causeList),
          )
          .toList();
    }

    preloadedCauseList.clear();
    preloadedCauseList = causeLists;
    return preloadedCauseList;
  }
}
