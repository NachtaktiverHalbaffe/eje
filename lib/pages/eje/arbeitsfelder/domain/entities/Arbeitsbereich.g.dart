// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Arbeitsbereich.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArbeitsbereichAdapter extends TypeAdapter<Arbeitsbereich> {
  @override
  final typeId = 3;

  @override
  Arbeitsbereich read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Arbeitsbereich(
      arbeitsfeld: fields[0] as String,
      bilder: (fields[1] as List)?.cast<String>(),
      inhalt: fields[2] as String,
      children: (fields[3] as List)?.cast<Object>(),
    );
  }

  @override
  void write(BinaryWriter writer, Arbeitsbereich obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.arbeitsfeld)
      ..writeByte(1)
      ..write(obj.bilder)
      ..writeByte(2)
      ..write(obj.inhalt)
      ..writeByte(3)
      ..write(obj.children);
  }
}
