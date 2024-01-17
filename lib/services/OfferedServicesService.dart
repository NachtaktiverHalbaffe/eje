import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/fixtures/data_services.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/CachedRemoteRepository.dart';
import 'package:eje/repositories/Repository.dart';
import 'package:hive/hive.dart';

class OfferedServicesService {
  final Repository<OfferedService, String> repository;

  OfferedServicesService({required this.repository});

  Future<Either<Failure, OfferedService>> getService(
      {OfferedService? service}) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.servicesBox);

    final result =
        await repository.getElement(appConfig.servicesBox, service!.service);
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }

  Future<Either<Failure, List<OfferedService>>> getServices() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.servicesBox);
    await dataServices(appConfig.servicesBox);

    final result = await repository.getAllElements(appConfig.servicesBox);
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }
}
