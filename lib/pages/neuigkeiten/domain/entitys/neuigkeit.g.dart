// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'neuigkeit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NeuigkeitAdapter extends TypeAdapter<Neuigkeit> {
  @override
  Neuigkeit read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Neuigkeit(
      titel: fields[0] as String,
      text_preview: fields[1] as String,
      text: fields[2] as String,
      bilder: (fields[3] as List)?.cast<String>(),
      weiterfuehrender_link: fields[4] as String,
      published: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Neuigkeit obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.titel)
      ..writeByte(1)
      ..write(obj.text_preview)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.bilder)
      ..writeByte(4)
      ..write(obj.weiterfuehrender_link)
      ..writeByte(5)
      ..write(obj.published);
  }


  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
