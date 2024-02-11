import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_case/database/interface/invoice_item_repo_interface.dart';
import 'package:smart_case/util/smart_case_init.dart';

class InvoiceItemRepo extends InvoiceItemRepoInterface {
  static final InvoiceItemRepo _instance = InvoiceItemRepo._internal();

  factory InvoiceItemRepo() {
    return _instance;
  }

  InvoiceItemRepo._internal();

  @override
  Future<dynamic> fetchAll({Map<String, dynamic>? body}) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${currentUser.token}',
      };
      var response = await client.get(
        Uri.https(
          currentUser.url.replaceRange(0, 8, ''),
          'api/admin/casePaymentType',
          body,
        ),
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
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${currentUser.token}',
      };

      var response = await client.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/admin/casePaymentType/$id'),
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
  Future<dynamic> post(Map<String, dynamic> data, int id) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${currentUser.token}',
      };

      var response = await client.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'api/admin/casePaymentType/create'),
        body: json.encode(data),
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

      var response = await client.put(
        Uri.https(currentUser.url.replaceRange(0, 8, ''),
            'admin/casePaymentType/update/$id'),
        body: json.encode(data),
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
  }
}
