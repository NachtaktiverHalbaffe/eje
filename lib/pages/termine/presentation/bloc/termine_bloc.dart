import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/termine/domain/usecases/getTermin.dart';
import 'package:eje/pages/termine/domain/usecases/get_Termine.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

class TermineBloc extends Bloc<TermineEvent, TermineState> {
  final String SERVER_FAILURE_MESSAGE =
      'Fehler beim Abrufen der Daten vom Server. Ist Ihr Gerät mit den Internet verbunden?';
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final GetTermine getTermine;
  final GetTermin getTermin;

  TermineBloc({
    @required this.getTermine,
    @required this.getTermin,
  });

  @override
  TermineState get initialState => Empty();

  @override
  Stream<TermineState> mapEventToState(
      TermineEvent event,
      ) async* {
    if (event is RefreshTermine) {
      print("Triggered Event: RefreshTermine");
      yield Loading();
      final termineOrFailure = await getTermine();
      yield  termineOrFailure.fold(
            (failure){
          print("Error");
          return Error(message:_mapFailureToMessage(failure));
        },
            (termine){
          print("Succes. Returning LoadedTermine");
          return LoadedTermine(termine);},
      );
    }
    else if(event is GettingTermin){
      yield Loading();
      final arbeitsbereicheOrFailure = await getTermin(veranstaltung: event.veranstaltung,dateTime:event.dateTime);
      yield arbeitsbereicheOrFailure.fold(
            (failure)=> Error(message:_mapFailureToMessage(failure)),
            (termin)=> LoadedTermin(termin),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unbekannter Fehler';
    }
  }
}
