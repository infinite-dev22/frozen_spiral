

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';

import '../../data/global_data.dart';
import '../../util/smart_case_init.dart';
import '../interface/drawer_repo_interface.dart';

class DrawerRepo extends DrawerRepoInterface {
  static final DrawerRepo _instance = DrawerRepo._internal();

  factory DrawerRepo() {
    return _instance;
  }

  DrawerRepo._internal();

  @override
  Future<Map<String, dynamic>> fetchAll({Map<String, dynamic>? body}) async {
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      dio.options.followRedirects = false;

      var response = await dio.get(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
                'api/accounts/cases/requisitions/allapi')
            .toString(),
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
  //   Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));
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

  // @override
  // Future<Map<String, dynamic>> filter() {
  //   // TODO: implement filter
  //   throw UnimplementedError();
  // }

  // @override
  // Future<dynamic> post(Map<String, dynamic> data, int id) async {
  //   Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));
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

  // @override
  // Future<dynamic> put(Map<String, dynamic> data, int id) async {
  //   Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));
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
