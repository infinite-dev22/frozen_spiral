import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/interface/password_repo_interface.dart';
import 'package:smart_case/util/smart_case_init.dart';

class PasswordRepo extends PasswordRepoInterface {
  static final PasswordRepo _instance = PasswordRepo._internal();

  factory PasswordRepo() {
    return _instance;
  }

  PasswordRepo._internal();

  // @override
  // Future<dynamic> post(Object data) async {
  //   var client = RetryClient(http.Client());
  //   try {
  //     final headers = {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //       "Authorization": 'Bearer ${currentUser.token}',
  //     };
  //
  //     var response = await client.post(
  //       Uri.https(currentUser.url.replaceRange(0, 8, ''),
  //           'api/hr/employees/changePasswordSubmit'),
  //       body: json.encode(data),
  //       headers: headers,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  //     } else {
  //       if (kDebugMode) {
  //         print("An Error occurred: ${response.statusCode}");
  //       }
  //       throw ErrorHint(
  //           "Action failed with status code: ${response.statusCode}");
  //     }
  //   } finally {
  //     client.close();
  //   }
  // }

  @override
  Future<dynamic> post(Object data) async {
    Dio dio = Dio(baseOps)
      ..interceptors.add(DioCacheInterceptor(options: options));

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      dio.options.followRedirects = false;

      var response = await dio.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
                'api/hr/employees/changePasswordSubmit')
            .toString(),
        data: json.encode(data),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("A Success occurred: ${response.statusCode}");
        }
        return response.data;
      } else {
        if (kDebugMode) {
          print("An Error occurred: ${response.statusCode}");
        }
      }
    } finally {
      dio.close();
    }
  }
}
