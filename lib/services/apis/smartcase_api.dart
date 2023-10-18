import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_case/models/activity.dart';
import 'package:smart_case/models/file.dart';
import 'package:smart_case/util/smart_case_init.dart';

class SmartCaseApi {
  static Future<List<SmartFile>> fetchAllFiles(String token,
      {Function()? onSuccess,
      Function()? onNoUser,
      Function()? onWrongPassword,
      Function()? onError}) async {
    var client = RetryClient(http.Client());

    try {
      var response = await client
          .get(Uri.parse('${currentUser.url}/api/cases?'), headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        List fileList = decodedResponse['search']['caseFiles']['original'];

        List<SmartFile> list =
            fileList.map((doc) => SmartFile.fromJson(doc)).toList();

        return list;
      } else {
        if (onError != null) {
          onError();
        }
      }
    }
    // catch (e) {
    //   if (onError != null) {
    //     onError();
    //   }
    // }
    finally {
      client.close();
    }
    return [];
  }

  static Future<List<Activity>> fetchAllActivities(String token,
      {Function()? onSuccess,
      Function()? onNoUser,
      Function()? onWrongPassword,
      Function()? onError}) async {
    var client = RetryClient(http.Client());

    try {
      var response = await client
          .get(Uri.parse('${currentUser.url}/api/admin/caseActivityStatus'), headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });
      var decodedResponse =
      jsonDecode(utf8.decode(response.bodyBytes)) as Map;

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;

        List activityList = decodedResponse['caseActivityStatus']['data'];

        List<Activity> list =
        activityList.map((doc) => Activity.fromJson(doc)).toList();

        return list;
      } else {
        if (onError != null) {
          onError();
        }
      }
    }
    // catch (e) {
    //   if (onError != null) {
    //     onError();
    //   }
    // }
    finally {
      client.close();
    }
    return [];
  }
}
