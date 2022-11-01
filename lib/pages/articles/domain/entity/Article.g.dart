// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Article.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 6;

  @override
  Article read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Article(
      url: fields[0] as String,
      titel: fields[1] as String,
      content: fields[2] as String,
      bilder: (fields[3] as List).cast<String>(),
      hyperlinks: (fields[4] as List).cast<Hyperlink>(),
    );
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.titel)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.bilder)
      ..writeByte(4)
      ..write(obj.hyperlinks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
