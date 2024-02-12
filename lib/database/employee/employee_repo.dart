import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
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

  @override
  Future<dynamic> post(Object data, int id) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": 'Bearer ${currentUser.token}',
      };
      var response = await client.get(
        Uri.https(
          currentUser.url.replaceRange(0, 8, ''),
          'api/activitiesindex',
          json.decode(json.encode(data)),
        ),
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
