// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BAKler.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BAKlerAdapter extends TypeAdapter<BAKler> {
  @override
  final typeId = 2;

  @override
  BAKler read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BAKler(
      bild: fields[0] as String,
      name: fields[1] as String,
      amt: fields[2] as String,
      vorstellung: fields[3] as String,
      email: fields[4] as String,
      threema: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BAKler obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.bild)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amt)
      ..writeByte(3)
      ..write(obj.vorstellung)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.threema);
  }
}