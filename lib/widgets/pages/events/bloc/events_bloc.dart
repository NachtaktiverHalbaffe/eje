// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/services/get_Event.dart';
import 'package:eje/services/get_Events.dart';

import './bloc.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEvents getEvents;
  final GetEvent getEvent;

  EventsBloc({
    required this.getEvents,
    required this.getEvent,
  }) : super(Empty()) {
    on<RefreshEvents>(_loadEvents);
    on<GettingEvent>(_loadSpecificEvent);
  }

  void _loadEvents(event, Emitter<EventsState> emit) async {
    print("Triggered Event: RefreshTermine");
    emit(Loading());
    final termineOrFailure = await getEvents();
    emit(termineOrFailure.fold(
      (failure) {
        print("Error");
        return Error(message: failure.getErrorMsg());
      },
      (termine) {
        print("Succes. Returning LoadedTermine");
        return LoadedEvents(termine);
      },
    ));
  }

  void _loadSpecificEvent(event, Emitter<EventsState> emit) async {
    emit(Loading());
    final arbeitsbereicheOrFailure = await getEvent(id: event.id);
    emit(arbeitsbereicheOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (termin) => LoadedEvent(termin),
    ));
  }
}
