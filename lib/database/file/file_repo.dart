import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_case/database/interface/file_repo_interface.dart';
import 'package:smart_case/util/smart_case_init.dart';

class FileRepo extends FileRepoInterface {
  static final FileRepo _instance = FileRepo._internal();

  factory FileRepo() {
    return _instance;
  }

  FileRepo._internal();

  @override
  Future<dynamic> fetchAll() async {
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
          'api/cases',
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
    return {};
  }
}
