part of 'services_bloc.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object> get props => [];
}

class Empty extends ServicesState {
  @override
  List<Object> get props => [];
}

class Loading extends ServicesState {
  @override
  List<Object> get props => [];
}

class LoadedServices extends ServicesState {
  final List<Service> services;

  LoadedServices(this.services);

  @override
  List<Object> get props => [services];
}

class LoadedService extends ServicesState {
  final Service service;

  LoadedService(this.service);

  @override
  List<Object> get props => [service];
}

class Error extends ServicesState {
  final String message;

  //Constructor
  Error({required this.message});

  @override
  List<Object> get props => [message];
}
