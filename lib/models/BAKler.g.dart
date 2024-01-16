// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BAKler.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BAKlerAdapter extends TypeAdapter<BAKler> {
  @override
  final int typeId = 2;

  @override
  BAKler read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BAKler(
      image: fields[0] as String,
      name: fields[1] as String,
      function: fields[2] as String,
      introduction: fields[3] as String,
      email: fields[4] as String,
      threema: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BAKler obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.function)
      ..writeByte(3)
      ..write(obj.introduction)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.threema);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BAKlerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
