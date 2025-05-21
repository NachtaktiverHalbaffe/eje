// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final typeId = 4;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      price: fields[9] == null ? 0 : (fields[9] as num).toInt(),
      price2: fields[10] == null ? 0 : (fields[10] as num).toInt(),
      ageFrom: fields[11] == null ? 0 : (fields[11] as num).toInt(),
      ageTo: fields[12] == null ? 0 : (fields[12] as num).toInt(),
      registrationEnd: fields[13] as DateTime,
      name: fields[0] as String,
      motto: fields[1] == null ? "" : fields[1] as String,
      description: fields[2] == null ? "" : fields[2] as String,
      images: (fields[3] as List).cast<String>(),
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
      location: fields[6] as Location,
      id: (fields[7] as num).toInt(),
      registrationLink: fields[8] == null ? "" : fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.motto)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.images)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.registrationLink)
      ..writeByte(9)
      ..write(obj.price)
      ..writeByte(10)
      ..write(obj.price2)
      ..writeByte(11)
      ..write(obj.ageFrom)
      ..writeByte(12)
      ..write(obj.ageTo)
      ..writeByte(13)
      ..write(obj.registrationEnd);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
