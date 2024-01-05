import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/interface/engagement_repo_interface.dart';
import 'package:smart_case/util/smart_case_init.dart';

class EngagementRepo extends EngagementRepoInterface {
  static final EngagementRepo _instance = EngagementRepo._internal();

  factory EngagementRepo() {
    return _instance;
  }

  EngagementRepo._internal();

  @override
  Future<Map<String, dynamic>> fetchAll(
      {Map<String, dynamic>? body, int page = 1}) async {
    Dio dio = Dio(baseOps)
      ..interceptors.add(DioCacheInterceptor(options: options));

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      dio.options.followRedirects = false;

      var response = await dio.get(
        '${currentUser.url}/api/admin/engagementypes',
        data: json.encode(body),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        if (kDebugMode) {
          print("An Error occurred: ${response.statusCode}");
        }
      }
    } finally {
      dio.close();
    }
    return {};
  }

// @override
// Future<Map<String, dynamic>> fetch(int id) async {
//   Dio dio = Dio(baseOps)
//     ..interceptors.add(DioCacheInterceptor(options: options));
//
//   try {
//     dio.options.headers['content-Type'] = 'application/json';
//     dio.options.headers['accept'] = 'application/json';
//     dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
//     dio.options.followRedirects = false;
//
//     var response = await dio.get(
//       Uri.https(currentUser.url.replaceRange(0, 8, ''),
//               'api/accounts/requisitions/$id/process')
//           .toString(),
//     );
//
//     if (response.statusCode == 200) {
//       return response.data;
//     } else {
//       if (kDebugMode) {
//         print("An Error occurred: ${response.statusCode}");
//       }
//     }
//   } finally {
//     dio.close();
//   }
//   return {};
// }
//
// @override
// Future<Map<String, dynamic>> filter() {
//   // TODO: implement filter
//   throw UnimplementedError();
// }
//
// @override
// Future<dynamic> post(Map<String, dynamic> data, int id) async {
//   Dio dio = Dio(baseOps)
//     ..interceptors.add(DioCacheInterceptor(options: options));
//
//   try {
//     dio.options.headers['content-Type'] = 'application/json';
//     dio.options.headers['Accept'] = 'application/json';
//     dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
//     dio.options.followRedirects = false;
//
//     var response = await dio.post(
//       Uri.https(currentUser.url.replaceRange(0, 8, ''),
//               'api/accounts/cases/$id/requisitions')
//           .toString(),
//       data: json.encode(data),
//     );
//
//     if (response.statusCode == 200) {
//       return response.data;
//     } else {
//       if (kDebugMode) {
//         print("An Error occurred: ${response.statusCode}");
//       }
//     }
//   } finally {
//     dio.close();
//   }
// }
//
// @override
// Future<dynamic> process(Map<String, dynamic> data, int id) async {
//   Dio dio = Dio(baseOps)
//     ..interceptors.add(DioCacheInterceptor(options: options));
//
//   try {
//     dio.options.headers['content-Type'] = 'application/json';
//     dio.options.headers['Accept'] = 'application/json';
//     dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
//     dio.options.followRedirects = false;
//
//     var response = await dio.post(
//       Uri.https(currentUser.url.replaceRange(0, 8, ''),
//               'api/accounts/requisitions/$id/process')
//           .toString(),
//       data: json.encode(data),
//     );
//
//     if (response.statusCode == 200) {
//       if (kDebugMode) {
//         print("A Success occurred: ${response.statusCode}");
//       }
//       return response.data;
//     } else {
//       if (kDebugMode) {
//         print("An Error occurred: ${response.statusCode}");
//       }
//       throw Exception("Got a status code ${response.statusCode} while "
//           "processing a requisition");
//     }
//   } finally {
//     dio.close();
//   }
// }
//
// @override
// Future<dynamic> put(Map<String, dynamic> data, int id) async {
//   Dio dio = Dio(baseOps)
//     ..interceptors.add(DioCacheInterceptor(options: options));
//
//   try {
//     dio.options.headers['content-Type'] = 'application/json';
//     dio.options.headers['Accept'] = 'application/json';
//     dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
//     // dio.options.followRedirects = false;
//
//     var response = await dio.put(
//       Uri.https(currentUser.url.replaceRange(0, 8, ''),
//               'api/accounts/cases/$id/requisitions')
//           .toString(),
//       data: json.encode(data),
//     );
//
//     if (response.statusCode == 200) {
//       if (kDebugMode) {
//         print("A Success occurred: ${response.statusCode}");
//       }
//       await EngagementApi
//           .fetchAll(); // TODO: Remove when bloc is successfully added.
//       return response.data;
//     } else {
//       if (kDebugMode) {
//         print("An Error occurred: ${response.statusCode}");
//       }
//     }
//   } finally {
//     dio.close();
//   }
// }
}
