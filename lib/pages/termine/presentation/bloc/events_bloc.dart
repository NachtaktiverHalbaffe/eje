// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/termine/domain/usecases/get_Event.dart';
import 'package:eje/pages/termine/domain/usecases/get_Events.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

class TermineBloc extends Bloc<EventsEvent, EventsState> {
  final String SERVER_FAILURE_MESSAGE =
      'Fehler beim Abrufen der Daten vom Server. Ist Ihr Gerät mit den Internet verbunden?';
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final GetEvents getEvents;
  final GetEvent getEvent;

  TermineBloc({
    @required this.getEvents,
    @required this.getEvent,
  }) : super(Empty());

  @override
  Stream<EventsState> mapEventToState(
    EventsEvent event,
  ) async* {
    if (event is RefreshEvents) {
      print("Triggered Event: RefreshTermine");
      yield Loading();
      final termineOrFailure = await getEvents();
      yield termineOrFailure.fold(
        (failure) {
          print("Error");
          return Error(message: _mapFailureToMessage(failure));
        },
        (termine) {
          print("Succes. Returning LoadedTermine");
          return LoadedEvents(termine);
        },
      );
    } else if (event is GettingEvent) {
      yield Loading();
      final arbeitsbereicheOrFailure = await getEvent(id: event.id);
      yield arbeitsbereicheOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (termin) => LoadedEvent(termin),
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
