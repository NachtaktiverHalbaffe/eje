// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/eje/services/domain/usecases/get_service.dart';
import 'package:eje/pages/eje/services/domain/usecases/get_services.dart';
import 'package:equatable/equatable.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final GetServices getServices;
  final GetService getService;

  ServicesBloc({
    required this.getService,
    required this.getServices,
  }) : super(Empty()) {
    on<RefreshServices>(_loadServices);
    on<GettingService>(_loadSpecificService);
  }

  void _loadServices(event, Emitter<ServicesState> emit) async {
    print("Triggered Event: RefreshServices");
    final servicesOrFailure = await getServices();
    emit(servicesOrFailure.fold(
      (failure) {
        print("Error");
        return Error(message: failure.getErrorMsg());
      },
      (services) {
        print("Success. Returning LoadedServices");
        return LoadedServices(services);
      },
    ));
  }

  void _loadSpecificService(event, Emitter<ServicesState> emit) async {
    print("Triggered Event: GettingService");

    final serviceOrFailure = await getService(service: event.service);
    emit(serviceOrFailure.fold(
      (failure) {
        print("Error while getting service");
        return Error(message: failure.getErrorMsg());
      },
      (service) {
        print("Success. Returning LoadedService");
        return LoadedService(service);
      },
    ));
  }
}
