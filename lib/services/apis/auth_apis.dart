import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get_secure_storage/get_secure_storage.dart';
import 'package:paulonia_cache_image/paulonia_cache_image.dart';
import 'package:smart_case/models/user.dart';
import 'package:smart_case/util/smart_case_init.dart';

import '../../data/global_data.dart';

class AuthApis {
  static Future uploadFCMToken(String email) async {
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${currentUser.token}";
    dio.options.followRedirects = false;

    try {
      await dio.post('https://app.smartcase.co.ug/api/save/fcm/token',
          data: jsonEncode({'fcm_token': currentUserFcmToken, 'email': email}));
    } finally {
      dio.close();
    }
  }

  static Future<CurrentSmartUser?> signInUser(
    String url,
    String email,
    String password, {
    Function()? onSuccess,
    Function()? onWrongPassword,
    Function()? onError,
  }) async {
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.followRedirects = false;

    try {
      var response = await dio.post(
          Uri.https(url.replaceRange(0, 8, ''), 'api/login').toString(),
          data: jsonEncode({'email': email, 'password': password}));

      if (response.statusCode == 200) {
        bool success = response.data['success'] as bool;

        if (success) {
          response.data['url'] = url;
          var user = CurrentSmartUser.fromJson(response.data);
          currentUser = user;

          if (onSuccess != null) {
            onSuccess();
          }
          return user;
        } else {
          if (response.data['message'] == 'WRONG_PASSWORD_PROVIDED') {
            if (onWrongPassword != null) {
              onWrongPassword();
            }
          }
        }
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
      dio.close();
    }
    return null;
  }

  static Future<String?> checkIfUserExists(
    String email, {
    Function()? onSuccess,
    Function()? onNoUser,
    Function()? onError,
  }) async {
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.followRedirects = false;

    try {
      var response = await dio.post(
          Uri.https('app.smartcase.co.ug', 'api/login').toString(),
          data: json.encode({
            'email': email,
          }));

      if (response.statusCode == 200) {
        bool success = response.data['success'] as bool;

        if (success) {
          return response.data['user']['app_url'];
        } else {
          if (response.data['message'] == 'USER_NOT_FOUND') {
            if (onNoUser != null) {
              onNoUser();
            }
          }
        }
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
      dio.close();
    }
    return null;
  }

  static Future signOutUser() async {
    final preferences = GetSecureStorage(
        password: 'infosec_technologies_ug_smart_case_law_manager');

    await preferences.remove('email');
    await preferences.remove('name');
    await preferences.remove('image');
  }

  static requestReset(String email,
      {Function()? onSuccess,
      Function()? onNoUser,
      Function()? onWrongPassword,
      Function()? onError,
      Function(dynamic e)? onErrors}) async {
    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.followRedirects = false;

    try {
      var response = await dio.post(
          Uri.https('app.smartcase.co.ug', 'api/login').toString(),
          data: json.encode({
            'email': email,
          }));

      if (response.statusCode == 200) {
        bool success = response.data['success'] as bool;

        if (success) {
          var url = response.data['user']['app_url'];

          var resetRequest = await dio.post(
              Uri.https(url.replaceRange(0, 8, ''), 'api/password/email')
                  .toString(),
              data: json.encode({'email': email}));

          if (resetRequest.statusCode == 200) {
            if (onSuccess != null) {
              onSuccess();
            }
          } else {
            if (onError != null) {
              onError();
            }
          }
        } else {
          if (response.data['message'] == 'USER_NOT_FOUND') {
            if (onNoUser != null) {
              onNoUser();
            }
          }
        }
      } else {
        if (onError != null) {
          onError();
        }
      }
    } finally {
      dio.close();
    }
  }
}
