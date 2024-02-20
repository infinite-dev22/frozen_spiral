import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/engagement/engagement_model.dart';
import 'package:smart_case/database/engagement/engagement_type_repo.dart';

class EngagementTypeApi {
  static Future<List<SmartEngagementType>> fetchAll(
      {Function()? onSuccess, Function? onError}) async {
    EngagementTypeRepo engagementTypeRepo = EngagementTypeRepo();
    List<SmartEngagementType> engagementTypes = List.empty(growable: true);

    var response = await engagementTypeRepo.fetchAll();
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
