import 'package:equatable/equatable.dart';

class News extends Equatable {
  final String title; //Titel der Neuigkeit
  final String textPreview; //Vorschautext der Neuigkeit
  final String text; //Eigentlicher, voller Textinhalt des Artikels
  final List<String> images; //Links zu den Bildern
  final String link; //Fals vorhanden hyperlinks zu anderen Websiten
  final DateTime published; //Veröffentlichungsdatum

  //Constructor
  News(
      {required this.title,
      required this.textPreview,
      required this.text,
      required this.images,
      this.link = "",
      DateTime? published})
      : published = published ?? DateTime.now();

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        title: json['title'] as String,
        textPreview: json['textPreview'] as String,
        text: json['text'] as String,
        images: (json['images'] as List).cast<String>(),
        link: json["link"] as String,
        published: json["published"] as DateTime);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'textPreview': textPreview,
      'text': text,
      'images': images.toString(),
      "link": link,
      "published": published
    };
  }

  @override
  List<Object> get props => [title, textPreview, text, images, link, published];
}
