import 'package:hive/hive.dart';
import 'package:smart_case/models/user.dart';

late CurrentSmartUser currentUser;
String? currentUsername;
String? currentUserFcmToken;
String? currentUserAvatar;
Box? localStorage;
