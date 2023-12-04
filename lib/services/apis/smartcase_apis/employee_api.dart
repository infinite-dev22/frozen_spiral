import 'package:smart_case/database/employee/employee_repo.dart';

class EmployeeApi {
  // static Future<List<SmartEmployee>> fetchAll(
  //     {int page = 1, Function()? onSuccess, Function? onError}) async {
  //   EmployeeRepo requisitionRepo = EmployeeRepo();
  //   List<SmartEmployee> requisitions = List.empty(growable: true);
  //
  //   var response = await requisitionRepo.fetchAll(page: page);
  //   List requisitionsMap = response['data'];
  //   requisitionNextPage = response["next_page_url"];
  //   List pagesList = response["links"];
  //   pagesLength = pagesList.length;
  //
  //   if (requisitionsMap.isNotEmpty) {
  //     requisitions = requisitionsMap
  //         .map(
  //           (requisition) => SmartEmployee.fromJson(requisition),
  //         )
  //         .toList();
  //   }
  //
  //   if (page == 1) {
  //     preloadedEmployees.clear();
  //   }
  //   preloadedEmployees.addAll(requisitions);
  //   return requisitions;
  // }

  // static Future<SmartEmployee?> fetch(int id,
  //     {Function()? onSuccess, Function()? onError}) async {
  //   EmployeeRepo requisitionRepo = EmployeeRepo();
  //   // DrawerRepo drawerRepo = DrawerRepo();
  //
  //   SmartEmployee? requisition;
  //   List drawersList;
  //   await requisitionRepo.fetch(id).then((response) {
  //     requisition = SmartEmployee.fromJson(response['requisition']);
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
  //   return requisition;
  // }
  //
  // static Future post(Map<String, dynamic> data, int id,
  //     {Function()? onSuccess, Function()? onError}) async {
  //   EmployeeRepo requisitionRepo = EmployeeRepo();
  //   var response = await requisitionRepo.post(data, id);
  //   return response;
  // }

  static post(Object data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    EmployeeRepo requisitionRepo = EmployeeRepo();

    var response = await requisitionRepo
        .post(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
