// ignore_for_file: non_constant_identifier_names
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_camp.dart';
import 'package:eje/pages/freizeiten/domain/usecases/get_camps.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

class CampsBloc extends Bloc<CampEvent, CampState> {
  final String SERVER_FAILURE_MESSAGE =
      'Fehler beim Abrufen der Daten vom Server. Ist Ihr Gerät mit den Internet verbunden?';
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final GetCamp getCamp;
  final GetCamps getCamps;

  CampsBloc({
    @required this.getCamp,
    @required this.getCamps,
  }) : super(Empty());

  @override
  Stream<CampState> mapEventToState(
    CampEvent event,
  ) async* {
    if (event is RefreshCamps) {
      yield Loading();
      final campOrFailure = await getCamps();
      yield campOrFailure.fold(
        (failure) {
          return Error(message: _mapFailureToMessage(failure));
        },
        (freizeiten) {
          return LoadedCamps(freizeiten);
        },
      );
    } else if (event is GettingCamp) {
      yield Loading();
      final campsOrFailure = await getCamp(freizeit: event.camp);
      yield campsOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (freizeit) => LoadedCamp(freizeit),
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
