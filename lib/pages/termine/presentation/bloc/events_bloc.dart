// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/pages/termine/domain/usecases/get_Event.dart';
import 'package:eje/pages/termine/domain/usecases/get_Events.dart';

import './bloc.dart';

class TermineBloc extends Bloc<EventsEvent, EventsState> {
  final GetEvents getEvents;
  final GetEvent getEvent;

  TermineBloc({
    required this.getEvents,
    required this.getEvent,
  }) : super(Empty()) {
    on<RefreshEvents>(_loadEvents);
    on<GettingEvent>(_loadSpecificEvent);
  }

  void _loadEvents(event, Emitter<EventsState> emit) async {
    print("Triggered Event: RefreshTermine");
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
    final arbeitsbereicheOrFailure = await getEvent(id: event.id);
    emit(arbeitsbereicheOrFailure.fold(
      (failure) => Error(message: failure.getErrorMsg()),
      (termin) => LoadedEvent(termin),
    ));
  }
}
