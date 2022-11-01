import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/eje/services/data/datasources/services_local_datasource.dart';
import 'package:eje/pages/eje/services/data/datasources/services_remote_datasource.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/eje/services/domain/repositories/services_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDatasource remoteDataSource;
  final ServicesLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  ServicesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDatasource,
    required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<Service>>> getServices() async {
    try {
      List<Service> service = await localDatasource.getCachedServices();
      return Right(service);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Service>> getService(Service service) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteService = await remoteDataSource.getService(service);
        await localDatasource.cacheService(remoteService);
        return Right(remoteService);
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        List<Service> services = await localDatasource.getCachedServices();
        for (var value in services) {
          if (value.service == service.service) {
            return Right(value);
          }
        }
        return Left(CacheFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
