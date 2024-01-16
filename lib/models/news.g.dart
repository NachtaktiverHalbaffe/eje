// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsAdapter extends TypeAdapter<News> {
  @override
  final int typeId = 0;

  @override
  News read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return News(
      title: fields[0] as String,
      textPreview: fields[1] as String,
      text: fields[2] as String,
      images: (fields[3] as List).cast<String>(),
      link: fields[4] as String,
      published: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, News obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.textPreview)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.images)
      ..writeByte(4)
      ..write(obj.link)
      ..writeByte(5)
      ..write(obj.published);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
