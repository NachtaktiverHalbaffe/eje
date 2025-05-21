import 'package:eje/models/hyperlink.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

part 'article.g.dart';

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
    required this.url,
    required this.titel,
    required this.content,
    required this.bilder,
    required this.hyperlinks,
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
