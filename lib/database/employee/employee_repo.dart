import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/interface/employee_repo_interface.dart';
import 'package:smart_case/util/smart_case_init.dart';

class EmployeeRepo extends EmployeeRepoInterface {
  static final EmployeeRepo _instance = EmployeeRepo._internal();

  factory EmployeeRepo() {
    return _instance;
  }

  EmployeeRepo._internal();

  // @override
  // Future<Map<String, dynamic>> fetchAll(
  //     {Map<String, dynamic>? body, int page = 1}) async {
  //   Dio dio = Dio(baseOps)..interceptors.add(DioCacheInterceptor(options: options));
  //
  //   try {
  //     dio.options.headers['content-Type'] = 'application/json';
  //     dio.options.headers['accept'] = 'application/json';
  //     dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
  //     dio.options.followRedirects = false;
  //
  //     var response = await dio.get(
  //       '${currentUser.url}/api/accounts/cases/requisitions/allapi?page=$page',
  //       data: json.encode(body),
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

  // @override
  // Future<Map<String, dynamic>> fetch(int id) async {
  //   Dio dio = Dio(baseOps)..interceptors.add(DioCacheInterceptor(options: options));
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
  //   Dio dio = Dio(baseOps)..interceptors.add(DioCacheInterceptor(options: options));
  //
  //   try {
  //     dio.options.headers['content-Type'] = 'application/json';
  //     dio.options.headers['Accept'] = 'application/json';
  //     dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
  //     // dio.options.followRedirects = false;
  //
  //     var response = await dio.post(
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

  @override
  Future<dynamic> post(Object data, int id) async {
    Dio dio = Dio(baseOps)
      ..interceptors.add(DioCacheInterceptor(options: options));

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      dio.options.followRedirects = false;

      var response = await dio.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
                'api/hr/employees/$id/update')
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

  @override
  Future<File> getAvatar() async {
    Dio dio = Dio(baseOps);

    try {
      dio.options.followRedirects = false;
      dio.options.responseType = ResponseType.bytes;

      var rand = Random().nextInt(2024);
      var response = await dio.get("$currentUserAvatar?v=$rand");

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("A Success occurred: ${response.statusCode}");
        }

        File file =
            File("${(await getTemporaryDirectory()).path}/user_pic.jpg");
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
        return file;
      } else {
        if (kDebugMode) {
          print("An Error occurred: ${response.statusCode}");
        }
      }
      return response.data;
    } finally {
      dio.close();
    }
  }
}
