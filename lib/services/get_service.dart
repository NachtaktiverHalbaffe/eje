import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/services_repository.dart';
import 'package:eje/services/usecase.dart';
import 'package:hive/hive.dart';

class GetService implements Service<OfferedService> {
  final ServicesRepository repository;

  GetService(this.repository);

  @override
  Future<Either<Failure, OfferedService>> call({
    OfferedService? service,
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
