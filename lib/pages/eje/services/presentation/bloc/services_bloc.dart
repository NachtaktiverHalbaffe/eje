// ignore_for_file: non_constant_identifier_names

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
          return Error(message: failure.getErrorMsg());
        },
        (services) {
          print("Success. Returning LoadedServices");
          return LoadedServices(services);
        },
      );
    } else if (event is GettingService) {
      print("Triggered Event: GettingService");
      yield Loading();
      final serviceOrFailure = await getService(service: event.service);
      yield serviceOrFailure.fold(
        (failure) {
          print("Error while getting service");
          return Error(message: failure.getErrorMsg());
        },
        (service) {
          print("Success. Returning LoadedService");
          return LoadedService(service);
        },
      );
    }
  }
}
