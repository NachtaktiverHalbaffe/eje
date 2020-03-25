import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:meta/meta.dart';

class NeuigkeitenModel extends Neuigkeit {
  NeuigkeitenModel({
    @required String titel,
    @required String text_preview,
    @required String text,
    @required List<String> bilder,
    String weiterfuehrender_link,
    DateTime published,
  }) : super(
          titel: titel,
          text_preview: text_preview,
          text: text,
          bilder: bilder,
          weiterfuehrender_link: weiterfuehrender_link,
          published: published,
        );

  factory NeuigkeitenModel.fromJson(Map<String, dynamic> json){
    return NeuigkeitenModel(
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
