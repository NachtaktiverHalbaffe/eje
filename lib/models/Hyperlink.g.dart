// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Hyperlink.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HyperlinkAdapter extends TypeAdapter<Hyperlink> {
  @override
  final int typeId = 9;

  @override
  Hyperlink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hyperlink(
      link: fields[0] as String,
      description: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Hyperlink obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.link)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperlinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
