import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/engagement/engagement_model.dart';
import 'package:smart_case/database/engagement/engagement_repo.dart';

class EngagementTypeApi {
  static Future<List<SmartEngagementType>> fetchAll(
      {Function()? onSuccess, Function? onError}) async {
    EngagementRepo engagementRepo = EngagementRepo();
    List<SmartEngagementType> engagementTypes = List.empty(growable: true);

    var response = await engagementRepo.fetchAll();
    List engagementTypesMap = response['engagementypes'];

    if (engagementTypesMap.isNotEmpty) {
      engagementTypes = engagementTypesMap
          .map(
            (engagement) => SmartEngagementType.fromJson(engagement),
          )
          .toList();
    }

    preloadedEngagementTypes.addAll(engagementTypes);
    return engagementTypes;
  }
}
