import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'Article.g.dart';

@HiveType(typeId: 6)
class Article extends Equatable {
  @HiveField(0)
  final String url;
  @HiveField(1)
  final String titel;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final List<String> bilder;
  @HiveField(4)
  final List<Hyperlink> hyperlinks;

  Article({
    this.url,
    this.titel,
    this.content,
    this.bilder,
    this.hyperlinks,
  });

  @override
  List<Object> get props => [
        url,
        titel,
        content,
        bilder,
        hyperlinks,
      ];
}
