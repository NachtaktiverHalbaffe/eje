// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 7;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
      kategorie: fields[0] as String,
      identifier: fields[1] as String,
      date: fields[2] as DateTime,
      notificationtext: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.kategorie)
      ..writeByte(1)
      ..write(obj.identifier)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.notificationtext);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
