import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_case/database/interface/invoice_repo_interface.dart';
import 'package:smart_case/util/smart_case_init.dart';

class InvoiceRepo extends InvoiceRepoInterface {
  static final InvoiceRepo _instance = InvoiceRepo._internal();

  factory InvoiceRepo() {
    return _instance;
  }

  InvoiceRepo._internal();

  @override
  Future<dynamic> fetchAll({Map<String, dynamic>? body}) async {
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
          /*'api/accounts/invoices',*/
          'api/accounts/invoice/indexapi',
          body,
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) as List;
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
              'api/accounts/invoices/$id'),
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

  @override
  Future<dynamic> post(Object data) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": 'Bearer ${currentUser.token}',
      };

      print("JSON DATA SENT 1: ${data}");
      print("JSON DATA SENT 2: ${json.encode(data)}");

      var response = await client.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/accounts/invoice/create'),
        body: json.encode(data),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print(
            "RESULT AFTER POST: ${jsonDecode(utf8.decode(response.bodyBytes)) as Map}");
        return jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      } else {
        if (kDebugMode) {
          print("An Error occurred: ${response.statusCode}");
          print("An Error occurred: ${response.body}");
        }
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
            'api/account/invoice/update/$id'),
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

      var response = await client.put(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/accounts/invoices/$id/approve'),
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
