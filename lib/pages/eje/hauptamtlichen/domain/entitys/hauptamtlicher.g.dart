// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hauptamtlicher.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HauptamtlicherAdapter extends TypeAdapter<Hauptamtlicher> {
  @override
  final int typeId = 1;

  @override
  Hauptamtlicher read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hauptamtlicher(
      bild: fields[0] as String,
      name: fields[1] as String,
      bereich: fields[2] as String,
      vorstellung: fields[3] as String,
      email: fields[4] as String,
      telefon: fields[5] as String,
      handy: fields[6] as String,
      threema: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Hauptamtlicher obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.bild)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.bereich)
      ..writeByte(3)
      ..write(obj.vorstellung)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.telefon)
      ..writeByte(6)
      ..write(obj.handy)
      ..writeByte(7)
      ..write(obj.threema);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HauptamtlicherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
