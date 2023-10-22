import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_case/models/user.dart';

late CurrentSmartUser currentUser;
String? currentUserImage;
String? currentUserEmail;
String? currentUsername;

const storage = FlutterSecureStorage();
