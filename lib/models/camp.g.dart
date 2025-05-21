// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CampAdapter extends TypeAdapter<Camp> {
  @override
  final typeId = 5;

  @override
  Camp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Camp(
      maxPlaces: (fields[8] as num).toInt(),
      faq: (fields[21] as List).cast<String>(),
      categories: (fields[22] as List).cast<String>(),
      name: fields[0] as String,
      startDate: fields[1] as DateTime,
      endDate: fields[2] as DateTime,
      ageFrom: (fields[3] as num).toInt(),
      ageTo: (fields[4] as num).toInt(),
      price: (fields[5] as num).toInt(),
      price2: (fields[6] as num).toInt(),
      occupancy: fields[7] as String,
      location: fields[9] as Location,
      registrationLink: fields[10] as String,
      pictures: (fields[11] as List).cast<String>(),
      description: fields[12] as String,
      teaser: fields[13] as String,
      registrationEnd: fields[14] as DateTime,
      catering: fields[15] as String,
      accommodation: fields[16] as String,
      journey: fields[17] as String,
      otherServices: fields[18] as String,
      subtitle: fields[19] as String,
      companions: (fields[20] as List).cast<String>(),
      termsDocument: fields[23] as String,
      infosheetDocument: fields[24] as String,
      privacyDocument: fields[25] as String,
      id: (fields[26] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Camp obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate)
      ..writeByte(3)
      ..write(obj.ageFrom)
      ..writeByte(4)
      ..write(obj.ageTo)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.price2)
      ..writeByte(7)
      ..write(obj.occupancy)
      ..writeByte(8)
      ..write(obj.maxPlaces)
      ..writeByte(9)
      ..write(obj.location)
      ..writeByte(10)
      ..write(obj.registrationLink)
      ..writeByte(11)
      ..write(obj.pictures)
      ..writeByte(12)
      ..write(obj.description)
      ..writeByte(13)
      ..write(obj.teaser)
      ..writeByte(14)
      ..write(obj.registrationEnd)
      ..writeByte(15)
      ..write(obj.catering)
      ..writeByte(16)
      ..write(obj.accommodation)
      ..writeByte(17)
      ..write(obj.journey)
      ..writeByte(18)
      ..write(obj.otherServices)
      ..writeByte(19)
      ..write(obj.subtitle)
      ..writeByte(20)
      ..write(obj.companions)
      ..writeByte(21)
      ..write(obj.faq)
      ..writeByte(22)
      ..write(obj.categories)
      ..writeByte(23)
      ..write(obj.termsDocument)
      ..writeByte(24)
      ..write(obj.infosheetDocument)
      ..writeByte(25)
      ..write(obj.privacyDocument)
      ..writeByte(26)
      ..write(obj.id);
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
