import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:moor_flutter/moor_flutter.dart';

class Neuigkeit extends Equatable {
  final String titel; //Titel der Neuigkeit
  final String text_preview; //Vorschautext der Neuigkeit
  final String text; //Eigentlicher, voller Textinhalt des Artikels
  final List<String> bilder; //Links zu den Bildern
  final String
      weiterfuehrender_link; //Fals vorhanden hyperlinks zu anderen Websiten
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
}
