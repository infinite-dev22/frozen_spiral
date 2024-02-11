import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_case/database/interface/invoice_type_repo_interface.dart';
import 'package:smart_case/util/smart_case_init.dart';

class InvoiceTypeRepo extends InvoiceTypeRepoInterface {
  static final InvoiceTypeRepo _instance = InvoiceTypeRepo._internal();

  factory InvoiceTypeRepo() {
    return _instance;
  }

  InvoiceTypeRepo._internal();

  @override
  Future<dynamic> fetchAll({Map<String, dynamic>? body}) async {
    var client = RetryClient(http.Client());
    try {
      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${currentUser.token}',
      };
      var response = client.get(
        Uri.https(
          currentUser.url.replaceRange(0, 8, ''),
          'api/admin/invoiceTypes',
          body,
        ),
        headers: headers,
      );

      response.then((data) {
        return jsonDecode(utf8.decode(data.bodyBytes)) as List;
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print("An Error occurred: $error \nStackTrace: $stackTrace");
        }
        throw error!;
      });
    } finally {
      client.close();
    }
    return [];
  }
}
