import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:smart_case/models/user.dart';

late CurrentSmartUser currentUser;
String? currentUserImage;
String? currentUsername;
String? currentUserFcmToken;
Box? localStorage;
