import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_case/models/employee.dart';

late Employee currentUser;
String? currentUserImage;
String? currentUserEmail;
String? currentUsername;

const storage = FlutterSecureStorage();
