// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Termin.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TerminAdapter extends TypeAdapter<Termin> {
  @override
  final typeId = 4;

  @override
  Termin read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Termin()
      ..veranstaltung = fields[0] as String
      ..motto = fields[1] as String
      ..text = fields[2] as String
      ..bild = fields[3] as String
      ..datum = fields[4] as String
      ..ort = fields[5] as Ort;
  }

  @override
  void write(BinaryWriter writer, Termin obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.veranstaltung)
      ..writeByte(1)
      ..write(obj.motto)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.bild)
      ..writeByte(4)
      ..write(obj.datum)
      ..writeByte(5)
      ..write(obj.ort);
  }
}
