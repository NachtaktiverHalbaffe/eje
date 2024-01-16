import 'package:dartz/dartz.dart';
import 'package:eje/datasources/services_local_datasource.dart';
import 'package:eje/datasources/services_remote_datasource.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/services_repository.dart';
import 'package:eje/utils/network_info.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDatasource remoteDataSource;
  final ServicesLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  ServicesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDatasource,
    required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<OfferedService>>> getServices() async {
    try {
      List<OfferedService> service = await localDatasource.getCachedServices();
      return Right(service);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, OfferedService>> getService(
      OfferedService service) async {
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
        List<OfferedService> services =
            await localDatasource.getCachedServices();
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
