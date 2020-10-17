// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Ort.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrtAdapter extends TypeAdapter<Ort> {
  @override
  final int typeId = 10;

  @override
  Ort read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ort(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Ort obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.Anschrift)
      ..writeByte(1)
      ..write(obj.Strasse)
      ..writeByte(2)
      ..write(obj.PLZ);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrtAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
