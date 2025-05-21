import 'package:eje/models/event.dart';
import 'package:equatable/equatable.dart';

abstract class EventsState extends Equatable {
  const EventsState();
  @override
  List<Object> get props => [];
}

class Empty extends EventsState {
  @override
  List<Object> get props => [];
}

class Loading extends EventsState {
  @override
  List<Object> get props => [];
}

class LoadedEvents extends EventsState {
  final List<Event> events;
  LoadedEvents(this.events);

  @override
  List<Object> get props => [events];
}

class LoadedEvent extends EventsState {
  final Event event;
  LoadedEvent(this.event);

  @override
  List<Object> get props => [event];
}

class Error extends EventsState {
  final String message;
  Error({required this.message});

  @override
  List<Object> get props => [message];
}

class NetworkError extends EventsState {
  final String message;

  NetworkError({required this.message});

  @override
  List<Object> get props => [message];
}
