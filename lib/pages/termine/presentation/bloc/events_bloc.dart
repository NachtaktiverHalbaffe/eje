// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/pages/termine/domain/usecases/get_Event.dart';
import 'package:eje/pages/termine/domain/usecases/get_Events.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

class TermineBloc extends Bloc<EventsEvent, EventsState> {
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
          return Error(message: failure.getErrorMsg());
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
        (failure) => Error(message: failure.getErrorMsg()),
        (termin) => LoadedEvent(termin),
      );
    }
  }
}
