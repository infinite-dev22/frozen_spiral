import '../../../data/app_config.dart';
import '../../../database/engagement/engagement_model.dart';
import '../../../database/engagement/engagement_repo.dart';

class EngagementTypeApi {
  static Future<List<SmartEngagementType>> fetchAll(
      {int page = 1, Function()? onSuccess, Function? onError}) async {
    EngagementRepo engagementRepo = EngagementRepo();
    List<SmartEngagementType> engagementTypes = List.empty(growable: true);

    var response = await engagementRepo.fetchAll(page: page);
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

// static Future<SmartEngagementType?> fetch(int id,
//     {Function()? onSuccess, Function()? onError}) async {
//   EngagementRepo engagementRepo = EngagementRepo();
//   // DrawerRepo drawerRepo = DrawerRepo();
//
//   SmartEngagementType? engagement;
//   List drawersList;
//   await engagementRepo.fetch(id).then((response) {
//     engagement = SmartEngagementType.fromJson(response['engagement']);
//
//     try {
//       drawersList = response['drawers'];
//       preloadedDrawers =
//           drawersList.map((drawer) => SmartDrawer.fromJson(drawer)).toList();
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   });
//
//   // SmartDrawer drawer = await drawerRepo
//   //     .fetch(id)
//   //     .then((response) => SmartDrawer.fromJson(response['drawer']));
//
//   return engagement;
// }
//
// static Future post(Map<String, dynamic> data, int id,
//     {Function()? onSuccess, Function()? onError}) async {
//   EngagementRepo engagementRepo = EngagementRepo();
//   var response = await engagementRepo
//       .post(data, id)
//       .then((value) => onSuccess!())
//       .onError((error, stackTrace) => onError!());
//   return response;
// }
//
// static Future process(Map<String, dynamic> data, int id,
//     {Function()? onSuccess, Function()? onError}) async {
//   EngagementRepo engagementRepo = EngagementRepo();
//   var response = await engagementRepo
//       .process(data, id)
//       .then((value) => onSuccess!())
//       .onError((error, stackTrace) => onError!());
//   return response;
// }
//
// static put(Map<String, dynamic> data, int id,
//     {Function()? onSuccess, Function()? onError}) async {
//   EngagementRepo engagementRepo = EngagementRepo();
//
//   var response = await engagementRepo
//       .put(data, id)
//       .then((value) => onSuccess!())
//       .onError((error, stackTrace) => onError!());
//   return response;
// }
}
