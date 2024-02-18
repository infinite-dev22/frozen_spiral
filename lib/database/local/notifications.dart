import 'package:hive/hive.dart';

part 'notifications.g.dart';

@HiveType(typeId: 1)
class Notifications {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? body;
  @HiveField(3)
  String? time;
  @HiveField(4, defaultValue: false)
  bool? read;

  Notifications({this.id, this.title, this.body, this.time, this.read});
}
