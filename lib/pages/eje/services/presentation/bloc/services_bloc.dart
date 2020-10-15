import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/eje/services/domain/usecases/GetService.dart';
import 'package:eje/pages/eje/services/domain/usecases/GetServices.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final String SERVER_FAILURE_MESSAGE =
      'Fehler beim Abrufen der Daten vom Server. Ist Ihr Gerät mit den Internet verbunden?';
  final String CACHE_FAILURE_MESSAGE =
      'Fehler beim Laden der Daten aus den Cache. Löschen Sie den Cache oder setzen sie die App zurück.';
  final GetServices getServices;
  final GetService getService;

  ServicesBloc({
    @required this.getService,
    @required this.getServices,
  }) : super(Empty());

  @override
  Stream<ServicesState> mapEventToState(
    ServicesEvent event,
  ) async* {
    if (event is RefreshServices) {
      print("Triggered Event: RefreshServices");
      yield Loading();
      final servicesOrFailure = await getServices();
      yield servicesOrFailure.fold(
        (failure) {
          print("Error");
          return Error(message: _mapFailureToMessage(failure));
        },
        (services) {
          print("Succes. Returning LoadedServices");
          return LoadedServices(services);
        },
      );
    } else if (event is GettingService) {
      yield Loading();
      final serviceOrFailure = await getService(service: event.service);
      yield serviceOrFailure.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (service) => LoadedService(service),
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
