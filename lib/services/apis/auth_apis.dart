import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:smart_case/models/employee.dart';
import 'package:smart_case/util/smart_case_init.dart';

class AuthApis {
  static signInUser(String email, String password,
      {Function()? onSuccess,
      Function()? onNoUser,
      Function()? onWrongPassword,
      Function()? onError,
      Function(dynamic e)? onErrors}) async {
    var client = RetryClient(http.Client());

    try {
      var response = await client
          .post(Uri.https('app.smartcase.co.ug', 'api/login'), body: {
        'email': email /*, 'password': password*/
      });
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      bool success = decodedResponse['success'] as bool;

      if (response.statusCode == 200) {
        if (success) {
          String url = decodedResponse['user']['app_url'];

          var userData = await client.post(
              Uri.https(url.replaceRange(0, 8, ''), 'api/login'),
              body: {'email': email, 'password': password});

          var userDataDecodedResponse =
              jsonDecode(utf8.decode(userData.bodyBytes)) as Map;

          bool userSuccess = userDataDecodedResponse['success'] as bool;

          userDataDecodedResponse['url'] = url;

          if (userSuccess) {
            currentUser = Employee.fromJson(userDataDecodedResponse);

            if (onSuccess != null) {
              onSuccess();
            }
          } else {
            if (userDataDecodedResponse['message'] == 'USER_NOT_FOUND') {
              if (onNoUser != null) {
                onNoUser();
              }
            } else if (userDataDecodedResponse['message'] ==
                'WRONG_PASSWORD_PROVIDED') {
              if (onWrongPassword != null) {
                onWrongPassword();
              }
            }
          }
        } else {
          if (decodedResponse['message'] == 'USER_NOT_FOUND') {
            if (onNoUser != null) {
              onNoUser();
            }
          } else if (decodedResponse['message'] == 'WRONG_PASSWORD_PROVIDED') {
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

      // For testing purposes only
      if (onErrors != null) {
        onErrors(e);
      }
    } finally {
      client.close();
    }
    return null;
  }

  static signOutUser(
      {required Function(void) onSuccess,
      required Function(Object object, StackTrace stackTrace) onError}) async {
    await storage.delete(key: 'email').then(onSuccess).onError(onError);
    await storage.delete(key: 'name').then(onSuccess).onError(onError);
    await storage.delete(key: 'image').then(onSuccess).onError(onError);
  }
}
