// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_of_work.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FieldOfWorkAdapter extends TypeAdapter<FieldOfWork> {
  @override
  final int typeId = 3;

  @override
  FieldOfWork read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FieldOfWork(
      name: fields[0] as String,
      images: (fields[1] as List).cast<String>(),
      description: fields[2] as String,
      link: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FieldOfWork obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.images)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldOfWorkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
