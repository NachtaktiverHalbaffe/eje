// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CampAdapter extends TypeAdapter<Camp> {
  @override
  final int typeId = 5;

  @override
  Camp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Camp(
      name: fields[0] as String,
      startDate: fields[1] as DateTime,
      endDate: fields[2] as DateTime,
      age: fields[3] as int,
      price: fields[4] as int,
      freePlaces: fields[5] as String,
      location: fields[6] as Ort,
      link: fields[7] as String,
      pictures: (fields[8] as List)?.cast<String>(),
      description: fields[9] as String,
      registrationDeadline: fields[10] as String,
      catering: fields[11] as String,
      lodging: fields[12] as String,
      journey: fields[13] as String,
      otherServices: fields[14] as String,
      subtitle: fields[15] as String,
      companion: (fields[16] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Camp obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.freePlaces)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.link)
      ..writeByte(8)
      ..write(obj.pictures)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.registrationDeadline)
      ..writeByte(11)
      ..write(obj.catering)
      ..writeByte(12)
      ..write(obj.lodging)
      ..writeByte(13)
      ..write(obj.journey)
      ..writeByte(14)
      ..write(obj.otherServices)
      ..writeByte(15)
      ..write(obj.subtitle)
      ..writeByte(16)
      ..write(obj.companion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CampAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
