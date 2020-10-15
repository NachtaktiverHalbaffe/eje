import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/eje/services/domain/repositories/services_repository.dart';
import 'package:flutter/material.dart';

class GetService implements UseCase<Service> {
  final ServicesRepository repository;

  GetService(this.repository);

  @override
  Future<Either<Failure, Service>> call({
    @required Service service,
  }) async {
    return await repository.getService(service);
  }
}
