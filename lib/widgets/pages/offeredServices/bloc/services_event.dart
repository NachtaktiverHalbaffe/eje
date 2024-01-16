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
  final OfferedService service;

  GettingService(this.service);

  @override
  List<Object> get props => [service];
}
