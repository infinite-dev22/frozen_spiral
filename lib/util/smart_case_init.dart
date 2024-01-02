import 'package:hive/hive.dart';
import 'package:smart_case/database/user/user_model.dart';

late CurrentSmartUser currentUser;
bool canApprove = false;

String? currentUsername;
String? currentUserFcmToken;
String? currentUserAvatar;
String? flowType;

Box? localStorage;
