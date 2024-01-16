import 'package:equatable/equatable.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class RefreshEvents extends EventsEvent {
  @override
  List<Object> get props => [];
}

class GettingEvent extends EventsEvent {
  final int id;
  GettingEvent(this.id);

  @override
  List<Object> get props => [id];
}
