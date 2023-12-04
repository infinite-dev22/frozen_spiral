import 'package:smart_case/database/password/password_repo.dart';

class PasswordApi {
  static post(Object data, {Function()? onSuccess, Function()? onError}) async {
    PasswordRepo fileRepo = PasswordRepo();

    var response = await fileRepo
        .post(data)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
