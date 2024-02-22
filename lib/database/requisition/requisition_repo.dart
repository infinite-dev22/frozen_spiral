import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/interface/requisition_repo_interface.dart';
import 'package:smart_case/util/smart_case_init.dart';

class RequisitionRepo extends RequisitionRepoInterface {
  static final RequisitionRepo _instance = RequisitionRepo._internal();

  factory RequisitionRepo() {
    return _instance;
  }

  RequisitionRepo._internal();

  @override
  Future<dynamic> fetchAll({int page = 1}) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": 'Bearer ${currentUser.token}',
      };
      var response = await client.get(
        Uri.parse(
            "${currentUser.url}/api/accounts/cases/requisitions/allapi?page=$page"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      } else {
        if (kDebugMode) {
          print("An Error occurred: ${response.statusCode}");
        }
      }
    } finally {
      client.close();
    }
    return {};
  }

  // @override
  // Future<dynamic> fetch(int id) async {
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
  //           'api/accounts/requisitions/$id/process'),
  //       headers: headers,
  //     );
  //
  //     log(response.body);
  //     print(response.headers);
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
  Future<Map<String, dynamic>> fetch(int id) async {
    Dio dio = Dio(baseOps)
      ..interceptors.add(DioCacheInterceptor(options: options));

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      dio.options.followRedirects = false;

      var response = await dio.get(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/accounts/requisitions/$id/process')
            .toString(),
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

  @override
  Future<dynamic> post(Map<String, dynamic> data, int id) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": 'Bearer ${currentUser.token}',
      };

      var response = await client.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/accounts/cases/$id/requisitions'),
        body: json.encode(data),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      } else {
        if (kDebugMode) {
          print("An Error occurred: ${response.statusCode}");
        }
        throw ErrorHint(
            "Action failed with status code: ${response.statusCode}");
      }
    } finally {
      client.close();
    }
  }

  // @override
  // Future<dynamic> process(Map<String, dynamic> data, int id) async {
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
  //           'api/accounts/requisitions/$id/process'),
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
  Future<dynamic> process(Map<String, dynamic> data, int id) async {
    Dio dio = Dio(baseOps)
      ..interceptors.add(DioCacheInterceptor(options: options));

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      dio.options.followRedirects = false;

      var response = await dio.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/accounts/requisitions/$id/process')
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
        throw Exception("Got a status code ${response.statusCode} while "
            "processing a requisition");
      }
    } finally {
      dio.close();
    }
  }

  @override
  Future<dynamic> put(Map<String, dynamic> data, int id) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": 'Bearer ${currentUser.token}',
      };

      var response = await client.put(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/accounts/cases/$id/requisitions'),
        body: json.encode(data),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      } else {
        if (kDebugMode) {
          print("An Error occurred: ${response.statusCode}");
        }
        throw ErrorHint(
            "Action failed with status code: ${response.statusCode}");
      }
    } finally {
      client.close();
    }
  }
}
