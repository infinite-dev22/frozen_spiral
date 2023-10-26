import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_case/models/smart_activity.dart';
import 'package:smart_case/models/smart_file.dart';
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
    } catch (e) {
      if (onError != null) {
        onError();
      }
    } finally {
      client.close();
    }
    return [];
  }

  static Future<List<SmartActivity>> fetchAllActivities(String token,
      {Function()? onSuccess,
      Function()? onNoUser,
      Function()? onWrongPassword,
      Function()? onError}) async {
    var client = RetryClient(http.Client());

    try {
      var response = await client.get(
          Uri.parse('${currentUser.url}/api/admin/caseActivityStatus'),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          });

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;

        List activityList = decodedResponse['caseActivityStatus']['data'];

        List<SmartActivity> list =
            activityList.map((doc) => SmartActivity.fromJson(doc)).toList();

        return list;
      } else {
        if (onError != null) {
          onError();
        }
      }
    } catch (e) {
      if (onError != null) {
        onError();
      }
    } finally {
      client.close();
    }
    return [];
  }

  static smartPost(String endPoint, String token, Object data,
      {Function()? onSuccess, Function()? onError}) async {
    var client = RetryClient(http.Client());

    try {
      // print(json.encode(data));
      // print(Uri.https(url.replaceRange(0, 8, ''), endPoint));
      // Dio dio = Dio();
      // dio.options.headers['content-Type'] = 'application/json';
      // dio.options.headers['Accept'] = 'application/json';
      // dio.options.headers["authorization"] =
      //     "Bearer $token";
      // dio.options.followRedirects = false;
      //
      // var response = await dio.post(
      //   Uri.https(url.replaceRange(0, 8, ''), endPoint).toString(),
      //   data: json.encode(data),
      // );

      final encoding = Encoding.getByName('utf-8');
      var response = await client.post(
          Uri.https(currentUser.url.replaceRange(0, 8, ''), endPoint),
          body: jsonEncode(data),
          encoding: encoding,
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            "content-Type": "application/json",
            "Accept": "application/json",
          });
      print(response.statusCode);
      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess();
        }
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

  static Future<Map> smartFetch(String endPoint, String token,
      {Function()? onSuccess, Function()? onError}) async {
    var client = RetryClient(http.Client());

    try {
      var response = await client.get(
          Uri.https(currentUser.url.replaceRange(0, 8, ''), endPoint),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          });

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;

        return decodedResponse;
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
    return {};
  }
}
