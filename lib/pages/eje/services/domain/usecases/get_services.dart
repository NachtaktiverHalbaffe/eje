import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/services/domain/entities/service.dart';
import 'package:eje/pages/eje/services/domain/repositories/services_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../../app_config.dart';

class GetServices implements UseCase<List<Service>> {
  final ServicesRepository repository;

  GetServices({@required this.repository});

  @override
  Future<Either<Failure, List<Service>>> call() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = await Hive.openBox(appConfig.servicesBox);
    final result = await repository.getServices();
    if (_box.isOpen) {
      await _box.compact();
      await _box.close();
    }
    return result;
  }
}