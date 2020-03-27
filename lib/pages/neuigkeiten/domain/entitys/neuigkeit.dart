import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

part 'neuigkeit.g.dart';

@HiveType(typeId:0)
class Neuigkeit extends Equatable {
  @HiveField(0)
  final String titel; //Titel der Neuigkeit
  @HiveField(1)
  final String text_preview; //Vorschautext der Neuigkeit
  @HiveField(2)
  final String text; //Eigentlicher, voller Textinhalt des Artikels
  @HiveField(3)
  final List<String> bilder; //Links zu den Bildern
  @HiveField(4)
  final String
      weiterfuehrender_link; //Fals vorhanden hyperlinks zu anderen Websiten
  @HiveField(5)
  final DateTime published; //Veröffentlichungsdatum

  //Constructor
  Neuigkeit(
      {@required this.titel,
      @required this.text_preview,
      @required this.text,
      @required this.bilder,
      this.weiterfuehrender_link,
      this.published})
      : super([
          titel,
          text_preview,
          text,
          bilder,
          weiterfuehrender_link,
          published
        ]);

  factory Neuigkeit.fromJson(Map<String, dynamic> json){
    return Neuigkeit(
      titel: json['titel'],
      text_preview: json['text_preview'],
      text: json['text'],
      bilder: (json['bilder'] as List<String>).toList(),
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'titel': titel,
      'text_preview': text_preview,
      'text': text,
      'bilder': bilder.toString()
    };
  }
}
