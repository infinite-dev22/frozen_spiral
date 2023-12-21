import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/data/global_data.dart';
import 'package:smart_case/util/smart_case_init.dart';

import '../interface/cause_list_repo_interface.dart';
import '../interface/done_activities_repo_interface.dart';

class DoneActivitiesRepo extends DoneActivitiesRepoInterface {
  static final DoneActivitiesRepo _instance = DoneActivitiesRepo._internal();

  factory DoneActivitiesRepo() {
    return _instance;
  }

  DoneActivitiesRepo._internal();

  @override
  Future<Map<String, dynamic>> fetchAll() async {
    Dio dio = Dio(baseOps)
      ..interceptors.add(DioCacheInterceptor(options: options));

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      dio.options.followRedirects = false;

      var response = await dio.get(Uri.https(
              currentUser.url.replaceRange(0, 8, ''),
              'api/reports/doneActivity')
          .toString());

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
}
