import 'package:eje/core/platform/Article.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NeuigkeitenBlocState extends Equatable {
  const NeuigkeitenBlocState();

  @override
  List<Object> get props => [];
}

//State wenn keine Neuigkeit vorhanden ist
class Empty extends NeuigkeitenBlocState {
  const Empty();

  @override
  List<Object> get props => [];
}

//State wenn Neuigkeiten geladen werden
class Loading extends NeuigkeitenBlocState {
  const Loading();

  @override
  List<Object> get props => [];
}

//State wenn ein Artikel geladen werden
class LoadingDetails extends NeuigkeitenBlocState {
  const LoadingDetails();

  @override
  List<Object> get props => [];
}

// State wenn Neuigkeien fertig geladen sind
class Loaded extends NeuigkeitenBlocState {
  final List<Neuigkeit> neuigkeit;

  //Constructor
  Loaded({@required this.neuigkeit}) {}

  @override
  List<Object> get props => [neuigkeit];
}

class LoadedDetail extends NeuigkeitenBlocState {
  final List<Article> article;

  //Constructor
  LoadedDetail({@required this.article});

  @override
  List<Object> get props => [article];
}

class Error extends NeuigkeitenBlocState {
  final String message;

  //Constructor
  Error({@required this.message});

  @override
  List<Object> get props => [message];
}
