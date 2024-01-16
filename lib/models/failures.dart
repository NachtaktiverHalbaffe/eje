import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];

  String getErrorMsg() {
    return "";
  }
}

class ServerFailure extends Failure {
  final String msg =
      "Fehler beim Abrufen der Daten vom Server. Überprüfen Sie die Internetverbindung oder kontaktieren Sie den Entwickler.";

  @override
  List<Object> get props => [];

  @override
  String getErrorMsg() {
    return msg;
  }
}

class ConnectionFailure extends Failure {
  final String msg =
      "Fehler bei dem Verbindungsversuch mit dem Server. Überprüfen Sie die Internetverbindung oder versuchen Sie es später erneut.";

  @override
  List<Object> get props => [];

  @override
  String getErrorMsg() {
    return msg;
  }
}

class CacheFailure extends Failure {
  final String msg =
      "Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.";

  @override
  List<Object> get props => [];

  @override
  String getErrorMsg() {
    return msg;
  }
}
