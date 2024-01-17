// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/models/Event.dart';
import 'package:eje/services/ReadOnlyService.dart';

import './bloc.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final ReadOnlyService<Event, int> eventService;

  EventsBloc({required this.eventService}) : super(Empty()) {
    on<RefreshEvents>(_loadEvents);
    on<GettingEvent>(_loadSpecificEvent);
  }

  void _loadEvents(event, Emitter<EventsState> emit) async {
    print("Triggered Event: RefreshTermine");
    emit(Loading());
    final termineOrFailure = await eventService.getAllElements();
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
    final arbeitsbereicheOrFailure =
        await eventService.getElement(id: event.id);
    emit(arbeitsbereicheOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (termin) => LoadedEvent(termin),
    ));
  }
}
