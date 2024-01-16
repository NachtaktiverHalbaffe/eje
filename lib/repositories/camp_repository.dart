import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/datasources/LocalDataSource.dart';
import 'package:eje/datasources/camps_remote_datasource.dart';
import 'package:eje/models/camp.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/utils/network_info.dart';
import 'package:get_storage/get_storage.dart';

class CampRepository {
  final CampsRemoteDatasource remoteDataSource;
  final LocalDataSource<Camp, int> localDatasource;
  final NetworkInfo networkInfo;

  CampRepository(
      {required this.remoteDataSource,
      required this.localDatasource,
      required this.networkInfo});

  Future<Either<Failure, List<Camp>>> getCamps() async {
    final AppConfig appConfig = await AppConfig.loadConfig();

    if (await networkInfo.isConnected) {
      try {
        final remoteFreizeiten = await remoteDataSource.getFreizeiten();
        await localDatasource.cacheElements(
            appConfig.campsBox, remoteFreizeiten);
        final camps = await localDatasource.getAllElements(appConfig.campsBox);
        _setPrefrenceCachedFreizeiten(camps);
        return Right(camps);
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        List<Camp> camps =
            await localDatasource.getAllElements(appConfig.campsBox);
        _setPrefrenceCachedFreizeiten(camps);
        return Right(camps);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  //Lade bestimmte Freizeit aus Cache
  Future<Either<Failure, Camp>> getCamp(int id) async {
    try {
      final AppConfig appConfig = await AppConfig.loadConfig();
      Camp camp =
          await localDatasource.getElement(appConfig.campsBox, id, "id");
      return Right(camp);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  void _setPrefrenceCachedFreizeiten(List<Camp> camps) {
    List<int> campsIds = List.empty(growable: true);
    for (var i = 0; i < camps.length; i++) {
      campsIds.add(camps[i].id);
    }
    GetStorage().write("cached_freizeiten", campsIds);
  }
}
