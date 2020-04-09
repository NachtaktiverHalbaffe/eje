import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_Freizeit.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_Freizeiten.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

class FreizeitenBloc extends Bloc<FreizeitenEvent, FreizeitenState> {
  final String SERVER_FAILURE_MESSAGE =
      'Fehler beim Abrufen der Daten vom Server. Ist Ihr Gerät mit den Internet verbunden?';
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final GetFreizeit getFreizeit;
  final GetFreizeiten getFreizeiten;

  FreizeitenBloc({
    @required this.getFreizeit,
    @required this.getFreizeiten,
  });

  @override
  FreizeitenState get initialState => Empty();

  @override
  Stream<FreizeitenState> mapEventToState(
      FreizeitenEvent event,
      ) async* {
    if (event is RefreshFreizeiten) {
      yield Loading();
      final freizeitenOrFailure = await getFreizeiten();
      yield  freizeitenOrFailure.fold(
            (failure){
          return Error(message:_mapFailureToMessage(failure));
        },
            (freizeiten){
          return LoadedFreizeiten(freizeiten);},
      );
    }
    else if(event is GettingFreizeit){
      yield Loading();
      final freizeitenOrFailure = await getFreizeit(freizeit:event.freizeit);
      yield freizeitenOrFailure.fold(
            (failure)=> Error(message:_mapFailureToMessage(failure)),
            (freizeit)=> LoadedFreizeit(freizeit),
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
