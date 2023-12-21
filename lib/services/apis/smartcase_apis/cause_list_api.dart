import 'package:smart_case/data/global_data.dart';

import '../../../database/reports/cause_list_repo.dart';
import '../../../database/reports/models/cause_list_report.dart';

class CauseListApi {
  static Future<List<SmartCauseListReport>> fetchAll() async {
    CauseListRepo causeListRepo = CauseListRepo();
    List<SmartCauseListReport> causeLists = List.empty(growable: true);

    var response = await causeListRepo.fetchAll();

    List causeListsMap = response['search']['nextActivities'];
    print("Dope List: ${causeListsMap.length}");

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
