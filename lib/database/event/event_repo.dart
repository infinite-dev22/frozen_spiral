import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_case/database/interface/event_repo_interface.dart';
import 'package:smart_case/util/smart_case_init.dart';

class EventRepo extends EventRepoInterface {
  static final EventRepo _instance = EventRepo._internal();

  factory EventRepo() {
    return _instance;
  }

  EventRepo._internal();

  @override
  Future<dynamic> fetchAll(
      {Map<String, dynamic>? body,
      Function()? onSuccess,
      Function()? onError}) async {
    var client = RetryClient(http.Client());

    try {
      var headers = {
        "Authorization": 'Bearer ${currentUser.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      var response = await client.get(
          Uri.https(currentUser.url.replaceRange(0, 8, ''),
              'api/calendar/eventsDispapi', body),
          headers: headers);

      if (response.statusCode == 200) {
        if (onSuccess != null) onSuccess();
        return jsonDecode(utf8.decode(response.bodyBytes)) as List;
        ;
      } else {
        if (onError != null) onError();
        if (kDebugMode) {
          print(
              "An Error Freakin Occurred Here Bro with status code: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (onError != null) {
        onError();
        if (kDebugMode) {
          print(e);
        }
      }
    } finally {
      client.close();
    }
    return [];
  }
}
