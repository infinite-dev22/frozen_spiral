import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
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
      var response = await await client.get(
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

  @override
  Future<dynamic> fetch(int id) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": 'Bearer ${currentUser.token}',
      };

      var response = await client.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/accounts/requisitions/$id/process'),
        headers: headers,
      );

      log(response.body);
      print(response.headers);

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

  @override
  Future<dynamic> process(Map<String, dynamic> data, int id) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": 'Bearer ${currentUser.token}',
      };

      var response = await client.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/accounts/requisitions/$id/process'),
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
