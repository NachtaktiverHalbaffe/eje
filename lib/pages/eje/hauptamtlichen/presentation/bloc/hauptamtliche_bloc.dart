// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/GetHauptamtliche.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/usecases/GetHauptamtlicher.dart';
import 'package:flutter/foundation.dart';
import './bloc.dart';

class HauptamtlicheBloc extends Bloc<HauptamtlicheEvent, HauptamtlicheState> {
  final String SERVER_FAILURE_MESSAGE =
      'Fehler beim Abrufen der Daten vom Server. Ist Ihr Gerät mit den Internet verbunden?';
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final GetHauptamtliche getHauptamtliche;
  final GetHauptamtlicher getHauptamtlicher;

  HauptamtlicheBloc({
    @required this.getHauptamtliche,
    @required this.getHauptamtlicher,
  }) : super(Empty());

  @override
  Stream<HauptamtlicheState> mapEventToState(
    HauptamtlicheEvent event,
  ) async* {
    if (event is RefreshHauptamtliche) {
      print("Triggered Event: RefreshHauptamtliche");
      yield Loading();
      final hauptamtlicheOrFailure = await getHauptamtliche();
      yield hauptamtlicheOrFailure.fold(
        (failure) {
          print("Error");
          return Error(message: _mapFailureToMessage(failure));
        },
        (hauptamtliche) {
          print("Succes. Returning LoadedHauptamtliche");
          return LoadedHauptamtliche(hauptamtliche);
        },
      );
    } else if (event is GettingHauptamtlicher) {
      yield Loading();
      final hauptamtlicheOrFailure = await getHauptamtlicher(name: event.name);
      yield hauptamtlicheOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (hauptamtlicher) => LoadedHauptamtlicher(hauptamtlicher),
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
