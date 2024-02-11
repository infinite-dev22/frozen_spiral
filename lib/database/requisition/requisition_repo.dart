import 'dart:convert';
import 'dart:io';

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
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${currentUser.token}',
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

  @override
  Future<Map<String, dynamic>> fetch(int id) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${currentUser.token}',
      };

      var response = client.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/accounts/requisitions/$id/process'),
        headers: headers,
      );

      response.then((data) {
        return jsonDecode(utf8.decode(data.bodyBytes)) as Map;
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print("An Error occurred: $error \nStackTrace: $stackTrace");
        }
        throw error!;
      });
    } finally {
      client.close();
    }
    return {};
  }

  @override
  Future<dynamic> post(Map<String, dynamic> data, int id) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${currentUser.token}',
      };

      var response = client.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/accounts/cases/$id/requisitions'),
        body: json.encode(data),
        headers: headers,
      );

      response.then((data) {
        return jsonDecode(utf8.decode(data.bodyBytes)) as Map;
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print("An Error occurred: $error \nStackTrace: $stackTrace");
        }
        throw error!;
      });
    } finally {
      client.close();
    }
  }

  @override
  Future<dynamic> process(Map<String, dynamic> data, int id) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${currentUser.token}',
      };

      var response = client.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/accounts/requisitions/$id/process'),
        body: json.encode(data),
        headers: headers,
      );

      response.then((data) {
        return jsonDecode(utf8.decode(data.bodyBytes)) as Map;
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print("An Error occurred: $error \nStackTrace: $stackTrace");
        }
        throw error!;
      });
    } finally {
      client.close();
    }
  }

  @override
  Future<dynamic> put(Map<String, dynamic> data, int id) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${currentUser.token}',
      };

      var response = client.put(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/accounts/cases/$id/requisitions'),
        body: json.encode(data),
        headers: headers,
      );

      response.then((data) {
        return jsonDecode(utf8.decode(data.bodyBytes)) as Map;
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print("An Error occurred: $error \nStackTrace: $stackTrace");
        }
        throw error!;
      });
    } finally {
      client.close();
    }
  }
}
