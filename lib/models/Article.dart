// ignore_for_file: file_names
import 'package:eje/models/Hyperlink.dart';
import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String url;
  final String titel;
  final String content;
  final List<String> bilder;
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

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      url: json["url"] as String,
      titel: json["title"] as String,
      content: json["content"] as String,
      bilder: (json["bilder"] as List).cast<String>(),
      hyperlinks: (json["hyperlinks"] as List).cast<Hyperlink>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "titel": titel,
      "content": content,
      "bilder": bilder,
      "hyperlinks": hyperlinks,
    };
  }
}
