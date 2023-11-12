part of 'notifications.dart';

class NotificationsAdapter extends TypeAdapter<Notifications> {
  @override
  Notifications read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Notifications()
      ..id = fields[0] as int?
      ..title = fields[1] as String?
      ..body = fields[2] as String?
      ..time = fields[3] as String?;
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  void write(BinaryWriter writer, Notifications obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.time);
  }

  @override
  int get typeId => 1;
}
