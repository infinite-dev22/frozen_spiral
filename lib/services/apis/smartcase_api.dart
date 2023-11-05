import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_case/models/smart_activity.dart';
import 'package:smart_case/models/smart_file.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:uuid/uuid.dart';

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
      var response = await client
          .get(Uri.parse('${currentUser.url}/api/activitiesindex'), headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      });

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;

        List activityList = decodedResponse['caseActivites'];

        print(activityList);

        List<SmartActivity> list =
            activityList.map((doc) => SmartActivity.fromJson(doc)).toList();

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

  static smartPost(String endPoint, String token, Object data,
      {Function()? onSuccess, Function()? onError}) async {
    var client = RetryClient(http.Client());

    print(jsonEncode(data));
    try {
      Dio dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer $token";
      dio.options.followRedirects = false;

      var response = await dio.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''), endPoint).toString(),
        data: json.encode(data),
      );
      print(response.statusCode);
      print(response.headers);
      print(response.data);
      // print(jsonDecode(utf8.decode(response.bodyBytes)) as Map);
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

  static smartPut(String endPoint, String token, Object data,
      {Function()? onSuccess, Function()? onError}) async {
    print(jsonEncode(data));

    var client = RetryClient(http.Client());
    try {
      final encoding = Encoding.getByName('utf-8');
      var response = await client.put(
          Uri.https(currentUser.url.replaceRange(0, 8, ''), endPoint),
          body: jsonEncode(data),
          encoding: encoding,
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            "content-Type": "application/json",
            "Accept": "application/json",
          });
      print(response.statusCode);
      print(response.headers);
      print(response.body);
      // print(jsonDecode(utf8.decode(response.bodyBytes)) as Map);
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
      {Map<String, dynamic>? body,
      Function()? onSuccess,
      Function()? onError}) async {
    var client = RetryClient(http.Client());

    try {
      var response = await client.get(
          Uri.https(currentUser.url.replaceRange(0, 8, ''), endPoint, body),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json'
          });

      // print(response.headers);
      // print(response.statusCode);
      // print(response.body);

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

  static Future smartDioFetch(String endPoint, String token,
      {Map<String, dynamic>? body,
      Function()? onSuccess,
      Function()? onError}) async {
    Dio dio = Dio();

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer $token";
      dio.options.followRedirects = false;

      var response = await dio.get(
        Uri.https(currentUser.url.replaceRange(0, 8, ''), endPoint).toString(),
        data: json.encode(body),
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.data);

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
      dio.close();
    }
    return {};
  }

  static Future<void> uploadProfilePicture(File imageFile,
      {Function()? onSuccess, Function()? onError}) async {
    String? uniquePhotoId = const Uuid().v4();
    File image = await compressImage(uniquePhotoId, imageFile);

    var client = RetryClient(http.Client());
    try {
      Dio dio = Dio();
      Uri url = Uri.https(currentUser.url.replaceRange(0, 8, ''),
          'api/hr/employees/update_avatarSubmit');

      FormData formData = FormData.fromMap({
        "employee_id": currentUser.id,
        "avatar": await MultipartFile.fromFile(image.path,
            filename: "$uniquePhotoId.png")
      });

      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      var response = await dio.post(url.toString(), data: formData);

      print(response.statusCode);
      print(response.headers);
      print(response.data);
      // print(jsonDecode(utf8.decode(response.bodyBytes)) as Map);
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
  }

  static Future<File> compressImage(String photoId, File image) async {
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;

    XFile? compressedImageXFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 55,
    );

    File compressedImage = File(compressedImageXFile!.path);
    return compressedImage;
  }
}
