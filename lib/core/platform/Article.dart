import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'Article.g.dart';

@HiveType(typeId: 6)
class Article extends Equatable {
  @HiveField(0)
  String url;
  @HiveField(1)
  String titel;
  @HiveField(2)
  String content;
  @HiveField(3)
  List<String> bilder;
  @HiveField(4)
  List<String> hyperlinks;

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
