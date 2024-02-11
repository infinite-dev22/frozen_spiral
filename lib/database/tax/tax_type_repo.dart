import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_case/database/interface/tax_type_repo_interface.dart';
import 'package:smart_case/util/smart_case_init.dart';

class TaxTypeRepo extends TaxTypeRepoInterface {
  static final TaxTypeRepo _instance = TaxTypeRepo._internal();

  factory TaxTypeRepo() {
    return _instance;
  }

  TaxTypeRepo._internal();

  @override
  Future<dynamic> fetchAll() async {
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
          'api/admin/taxes',
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
}
