import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/eje/services/domain/repositories/services_repository.dart';
import 'package:hive/hive.dart';

class GetService implements UseCase<Service> {
  final ServicesRepository repository;

  GetService(this.repository);

  @override
  Future<Either<Failure, Service>> call({
    Service? service,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.servicesBox);
    final result = await repository.getService(service!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }
}
