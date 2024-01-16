import 'package:dartz/dartz.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/services_repository.dart';
import 'package:eje/services/usecase.dart';
import 'package:hive/hive.dart';

import '../../../../../app_config.dart';

class GetServices implements Service<List<OfferedService>> {
  final ServicesRepository repository;

  GetServices({required this.repository});

  @override
  Future<Either<Failure, List<OfferedService>>> call() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.servicesBox);
    final result = await repository.getServices();
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }
}
