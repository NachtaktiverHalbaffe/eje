// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Service.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceAdapter extends TypeAdapter<Service> {
  @override
  final int typeId = 8;

  @override
  Service read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Service(
      service: fields[0] as String,
      images: (fields[1] as List).cast<String>(),
      description: fields[2] as String,
      hyperlinks: (fields[3] as List).cast<Hyperlink>(),
    );
  }

  @override
  void write(BinaryWriter writer, Service obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.service)
      ..writeByte(1)
      ..write(obj.images)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.hyperlinks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
