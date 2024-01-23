import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/fixtures/data_services.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/CachedRemoteRepository.dart';

class OfferedServicesService {
  final CachedRemoteRepository<OfferedService, String> repository;

  OfferedServicesService({required this.repository});

  Future<Either<Failure, OfferedService>> getService(
      {OfferedService? service}) async {
    final result = await repository.getElement(service!.service);

    return result;
  }

  Future<Either<Failure, List<OfferedService>>> getServices() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    await dataServices(appConfig.servicesBox);

    final result = await repository.getAllElements();
    return result;
  }

  Future<Either<Failure, List<OfferedService>>> getCachedServices() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    await dataServices(appConfig.servicesBox);

    final result = await repository.getAllCachedElements();

    return result;
  }
}
