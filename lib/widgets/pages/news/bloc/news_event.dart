import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

// Zeige ganzen Artikel wenn Button geklicket wird
class GetNewsDetails extends NewsEvent {
  final String url;

  //Constructor
  GetNewsDetails(this.url);
  @override
  List<Object> get props => [url];
}

// Refreshe Neuigkeiten, wenn Liste zum refresen runter gezogen wird
class RefreshNews extends NewsEvent {}

class GetCachedNews extends NewsEvent {}
