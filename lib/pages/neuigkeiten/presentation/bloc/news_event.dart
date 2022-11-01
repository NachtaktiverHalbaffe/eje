import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

// Zeige ganzen Artikel wenn Button geklicket wird
class GetNewsDetails extends NewsEvent {
  final String title;

  //Constructor
  GetNewsDetails(this.title);
  @override
  List<Object> get props => [title];
}

// Refreshe Neuigkeiten, wenn Liste zum refresen runter gezogen wird
class RefreshNews extends NewsEvent {}
