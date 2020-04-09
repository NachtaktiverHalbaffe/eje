// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Freizeit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FreizeitAdapter extends TypeAdapter<Freizeit> {
  @override
  final typeId = 5;

  @override
  Freizeit read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Freizeit(
      freizeit: fields[0] as String,
      datum: fields[1] as String,
      alter: fields[2] as String,
      preis: fields[3] as String,
      platz_frei: fields[4] as String,
      ort: fields[5] as Ort,
      link: fields[6] as String,
      bilder: (fields[7] as List)?.cast<String>(),
      beschreibung: fields[8] as String,
      anmeldeschluss: fields[9] as String,
      verpflegung: fields[10] as String,
      unterbringung: fields[11] as String,
      anreise: fields[12] as String,
      sonstige_leistungen: fields[13] as String,
      motto: fields[14] as String,
      begleiter: (fields[15] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Freizeit obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.freizeit)
      ..writeByte(1)
      ..write(obj.datum)
      ..writeByte(2)
      ..write(obj.alter)
      ..writeByte(3)
      ..write(obj.preis)
      ..writeByte(4)
      ..write(obj.platz_frei)
      ..writeByte(5)
      ..write(obj.ort)
      ..writeByte(6)
      ..write(obj.link)
      ..writeByte(7)
      ..write(obj.bilder)
      ..writeByte(8)
      ..write(obj.beschreibung)
      ..writeByte(9)
      ..write(obj.anmeldeschluss)
      ..writeByte(10)
      ..write(obj.verpflegung)
      ..writeByte(11)
      ..write(obj.unterbringung)
      ..writeByte(12)
      ..write(obj.anreise)
      ..writeByte(13)
      ..write(obj.sonstige_leistungen)
      ..writeByte(14)
      ..write(obj.motto)
      ..writeByte(15)
      ..write(obj.begleiter);
  }
}
