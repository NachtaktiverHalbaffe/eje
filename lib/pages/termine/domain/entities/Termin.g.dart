// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Termin.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TerminAdapter extends TypeAdapter<Termin> {
  @override
  final int typeId = 4;

  @override
  Termin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Termin(
      veranstaltung: fields[0] as String,
      motto: fields[1] as String,
      text: fields[2] as String,
      bild: fields[3] as String,
      datum: fields[4] as String,
      ort: fields[5] as Ort,
    );
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

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TerminAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
