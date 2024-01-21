// ignore_for_file: non_constant_identifier_names
import 'package:bloc/bloc.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/services/OfferedServicesService.dart';
import 'package:equatable/equatable.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final OfferedServicesService offeredServicesService;

  ServicesBloc({required this.offeredServicesService}) : super(Empty()) {
    on<RefreshServices>(_loadServices);
    on<GettingService>(_loadSpecificService);
    on<GetCachedServices>(_loadCachedServices);
  }

  void _loadServices(event, Emitter<ServicesState> emit) async {
    print("Triggered Event: RefreshServices");
    emit(Loading());
    final servicesOrFailure = await offeredServicesService.getServices();
    emit(servicesOrFailure.fold(
      (failure) {
        print("Error");
        if (failure is ConnectionFailure) {
          return NetworkError(message: failure.getErrorMsg());
        }
        return Error(message: failure.getErrorMsg());
      },
      (services) {
        print("Success. Returning LoadedServices");
        return LoadedServices(services);
      },
    ));
  }

  void _loadCachedServices(event, Emitter<ServicesState> emit) async {
    print("Triggered Event: RefreshServices");
    emit(Loading());
    final servicesOrFailure = await offeredServicesService.getCachedServices();
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
    emit(Loading());
    final serviceOrFailure =
        await offeredServicesService.getService(service: event.service);
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
