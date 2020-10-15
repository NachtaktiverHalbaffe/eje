import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/eje/services/domain/repositories/services_repository.dart';
import 'package:flutter/material.dart';

class GetServices implements UseCase<List<Service>> {
  final ServicesRepository repository;

  GetServices({@required this.repository});

  @override
  Future<Either<Failure, List<Service>>> call() async {
    return await repository.getServices();
  }
}
