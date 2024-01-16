import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/datasources/LocalDataSource.dart';
import 'package:eje/datasources/services_remote_datasource.dart';
import 'package:eje/fixtures/data_services.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/utils/network_info.dart';
import 'package:hive/hive.dart';

class ServicesRepository {
  final ServicesRemoteDatasource remoteDataSource;
  final LocalDataSource<OfferedService, String> localDatasource;
  final NetworkInfo networkInfo;

  ServicesRepository(
      {required this.remoteDataSource,
      required this.localDatasource,
      required this.networkInfo});

  //Lade Artikel aus den Internet herunter
  Future<Either<Failure, List<OfferedService>>> getServices() async {
    final AppConfig appConfig = await AppConfig.loadConfig();

    try {
      final Box box = Hive.box(appConfig.servicesBox);
      dataServices(box);

      List<OfferedService> service =
          await localDatasource.getAllElements(appConfig.servicesBox);
      return Right(service);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  //Lade bestimmten Artikel aus Cache
  Future<Either<Failure, OfferedService>> getService(
      OfferedService service) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    if (await networkInfo.isConnected) {
      try {
        final remoteService = await remoteDataSource.getService(service);
        await localDatasource.cacheElement(
            appConfig.servicesBox, remoteService);
        return Right(remoteService);
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        OfferedService offeredService = await localDatasource.getElement(
            appConfig.servicesBox, service.service, "service");
        return Right(offeredService);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
