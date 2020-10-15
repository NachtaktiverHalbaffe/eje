part of 'services_bloc.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object> get props => [];
}

class RefreshServices extends ServicesEvent {
  @override
  List<Object> get props => [];
}

class GettingService extends ServicesEvent {
  Service service;

  GettingService(@required this.service);

  @override
  List<Object> get props => [service];
}
