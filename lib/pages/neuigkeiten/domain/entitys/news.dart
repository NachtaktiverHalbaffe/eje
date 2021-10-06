import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

part 'news.g.dart';

@HiveType(typeId: 0)
class News extends Equatable {
  @HiveField(0)
  final String title; //Titel der Neuigkeit
  @HiveField(1)
  final String textPreview; //Vorschautext der Neuigkeit
  @HiveField(2)
  final String text; //Eigentlicher, voller Textinhalt des Artikels
  @HiveField(3)
  final List<String> images; //Links zu den Bildern
  @HiveField(4)
  final String link; //Fals vorhanden hyperlinks zu anderen Websiten
  @HiveField(5)
  final DateTime published; //Veröffentlichungsdatum

  //Constructor
  News(
      {@required this.title,
      @required this.textPreview,
      @required this.text,
      @required this.images,
      this.link,
      this.published});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['titel'],
      textPreview: json['text_preview'],
      text: json['text'],
      images: (json['bilder'] as List<String>).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titel': title,
      'text_preview': textPreview,
      'text': text,
      'bilder': images.toString()
    };
  }

  @override
  List<Object> get props => [title, textPreview, text, images, link, published];
}
