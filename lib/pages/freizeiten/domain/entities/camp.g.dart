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
      datum: fields[1] as String,
      age: fields[2] as String,
      price: fields[3] as String,
      freePlaces: fields[4] as String,
      location: fields[5] as Ort,
      link: fields[6] as String,
      pictures: (fields[7] as List)?.cast<String>(),
      description: fields[8] as String,
      registrationDeadline: fields[9] as String,
      catering: fields[10] as String,
      lodging: fields[11] as String,
      journey: fields[12] as String,
      otherServices: fields[13] as String,
      subtitle: fields[14] as String,
      companion: (fields[15] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Camp obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.datum)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.freePlaces)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.link)
      ..writeByte(7)
      ..write(obj.pictures)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.registrationDeadline)
      ..writeByte(10)
      ..write(obj.catering)
      ..writeByte(11)
      ..write(obj.lodging)
      ..writeByte(12)
      ..write(obj.journey)
      ..writeByte(13)
      ..write(obj.otherServices)
      ..writeByte(14)
      ..write(obj.subtitle)
      ..writeByte(15)
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
