import 'package:eje/models/article.dart';
import 'package:eje/models/news.dart';
import 'package:equatable/equatable.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

//State wenn keine Neuigkeit vorhanden ist
class Empty extends NewsState {
  const Empty();

  @override
  List<Object> get props => [];
}

//State wenn Neuigkeiten geladen werden
class Loading extends NewsState {
  const Loading();

  @override
  List<Object> get props => [];
}

//State wenn ein Artikel geladen werden
class LoadingNewsDetails extends NewsState {
  const LoadingNewsDetails();

  @override
  List<Object> get props => [];
}

// State wenn Neuigkeien fertig geladen sind
class Loaded extends NewsState {
  final List<News> neuigkeit;

  //Constructor
  Loaded({required this.neuigkeit});

  @override
  List<Object> get props => [neuigkeit];
}

class LoadedNewsDetails extends NewsState {
  final Article article;

  //Constructor
  LoadedNewsDetails({required this.article});

  @override
  List<Object> get props => [article];
}

class Error extends NewsState {
  final String message;

  //Constructor
  Error({required this.message});

  @override
  List<Object> get props => [message];
}

class NetworkError extends NewsState {
  final String message;

  //Constructor
  NetworkError({required this.message});

  @override
  List<Object> get props => [message];
}
