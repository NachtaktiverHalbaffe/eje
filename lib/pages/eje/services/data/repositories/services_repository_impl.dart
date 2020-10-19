import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/eje/services/data/datasources/ServicesLocalDatasource.dart';
import 'package:eje/pages/eje/services/data/datasources/ServicesRemoteDatasource.dart';
import 'package:eje/pages/eje/services/domain/entities/ErrorService.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/eje/services/domain/repositories/services_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDatasource remoteDataSource;
  final ServicesLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  ServicesRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<Service>>> getServices() async {
    List<Service> _service = localDatasource.getCachedServices();
    return Right(_service);
  }

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Service>> getService(Service service) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteService = await remoteDataSource.getService(service);
        localDatasource.cacheService(remoteService);
        Service _service =
            await localDatasource.getService(remoteService.service);
        return Right(_service);
      } on ServerException {
        return Right(getErrorService());
      }
    } else
      try {
        List<Service> _services = localDatasource.getCachedServices();
        for (var value in _services) {
          if (value.service == service.service) {
            return Right(value);
          }
        }
      } on CacheException {
        return Right(getErrorService());
      }
  }
}
