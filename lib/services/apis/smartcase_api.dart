import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_case/data/global_data.dart';
import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/models/smart_event.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:uuid/uuid.dart';

import '../../theme/color.dart';

class SmartCaseApi {
  static Future<List<SmartRequisition>> fetchAllRequisitions(String token,
      {Function()? onSuccess, Function()? onError}) async {
    var client = RetryClient(http.Client());

    try {
      var response = await client.get(
          Uri.parse(
              '${currentUser.url}/api/accounts/cases/requisitions/allapi'),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
          });

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;

        List requisitionList = decodedResponse['search']['requisitions'];

        List<SmartRequisition> list = requisitionList
            .map((doc) => SmartRequisition.fromJson(doc))
            .toList();

        return list;
      } else {
        if (onError != null) {
          onError();
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

  static smartPost(String endPoint, String token, Object data,
      {Function()? onSuccess, Function()? onError}) async {
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));

    try {
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer $token";
      // dio.options.followRedirects = false;

      var response = await dio.post(
        Uri.https(currentUser.url.replaceRange(0, 8, ''), endPoint).toString(),
        data: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 302) {
        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        if (onError != null) {
          onError();
        }
      }
    } catch (e) {
      if (onError != null) {
        onError();
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        if (kDebugMode) {
          print(e);
        }
      }
    } finally {
      dio.close();
    }
    return [];
  }

  static smartPut(String endPoint, String token, Object data,
      {Function()? onSuccess, Function()? onError}) async {
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

      if (response.statusCode == 200) {
        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        if (onError != null) {
          onError();
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

      if (response.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;

        return decodedResponse;
      } else {
        if (onError != null) {
          onError();
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
    return {};
  }

  static Future smartDioFetch(String endPoint, String token,
      {Map<String, dynamic>? body,
      Function()? onSuccess,
      Function()? onError}) async {
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));

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
        return response.data;
      } else {
        if (onError != null) {
          onError();
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
      Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));
      Uri url = Uri.https(currentUser.url.replaceRange(0, 8, ''),
          'api/hr/employees/update_avatarSubmit');

      FormData formData = FormData.fromMap({
        "employee_id": currentUser.id,
        "avatar": await MultipartFile.fromFile(image.path,
            filename: "$uniquePhotoId.png")
      });

      dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
      var response = await dio.post(url.toString(), data: formData);

      if (response.statusCode == 200) {
        currentUser.avatar = response.data["avatar"];

        final box = GetSecureStorage(
            password: 'infosec_technologies_ug_smart_case_law_manager');
        box.write('image', currentUser.avatar);

        print("New: ${response.data["avatar"]}");
        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        if (onError != null) {
          onError();
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
  }

  static Future<Map<DateTime, List<SmartEvent>>> fetchAllEvents(String token,
      {Function()? onSuccess, Function()? onError}) async {
    final DateTime today = DateTime.now();

    var responseEventsList = await SmartCaseApi.smartDioFetch(
        'api/calendar/events', currentUser.token,
        body: {
          "start": "${today.year}-${today.month}-01",
          "end":
              "${today.year}-${today.month}-${DateTime(today.year, today.month + 1, 0).day}",
          "viewRdbtn": "all",
          "isFirmEventRdbtn": "ALLEVENTS",
          "checkedChk": ["MEETING", "NEXTACTIVITY", "LEAVE", "HOLIDAY"],
        },
        onSuccess: onSuccess,
        onError: onError);
    List eventsList = responseEventsList;

    List<SmartEvent> events =
        eventsList.map((doc) => SmartEvent.fromJson(doc)).toList();

    var dataCollection = <DateTime, List<SmartEvent>>{};
    final DateTime rangeStartDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: -1000));
    final DateTime rangeEndDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 1000));
    for (DateTime i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(const Duration(days: 1))) {
      final DateTime date = i;
      for (int j = 0; j < events.length; j++) {
        final SmartEvent event = SmartEvent(
          title: events[j].description,
          startDate: events[j].startDate,
          endDate: events[j].endDate,
          backgroundColor: events[j].backgroundColor,
        );

        if (dataCollection.containsKey(date)) {
          final List<SmartEvent> events = dataCollection[date]!;
          events.add(event);
          dataCollection[date] = events;
        } else {
          dataCollection[date] = [event];
        }
      }
    }
    return dataCollection;
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
