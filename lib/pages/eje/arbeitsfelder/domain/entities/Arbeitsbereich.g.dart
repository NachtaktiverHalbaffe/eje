// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Arbeitsbereich.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArbeitsbereichAdapter extends TypeAdapter<Arbeitsbereich> {
  @override
  final int typeId = 3;

  @override
  Arbeitsbereich read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Arbeitsbereich(
      arbeitsfeld: fields[0] as String,
      bilder: (fields[1] as List)?.cast<String>(),
      inhalt: fields[2] as String,
      url: fields[3] as String,
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
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArbeitsbereichAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
