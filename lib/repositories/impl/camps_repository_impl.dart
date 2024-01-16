import 'package:dartz/dartz.dart';
import 'package:eje/datasources/camps_local_datasource.dart';
import 'package:eje/datasources/camps_remote_datasource.dart';
import 'package:eje/models/camp.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/camp_repository.dart';
import 'package:eje/utils/network_info.dart';
import 'package:get_storage/get_storage.dart';

class CampRepositoryImpl implements CampRepository {
  final CampsRemoteDatasource remoteDataSource;
  final CampsLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  CampRepositoryImpl({
    required this.remoteDataSource,
    required this.localDatasource,
    required this.networkInfo,
  });

  //Lade Freizeiten aus den Internet herunter
  @override
  Future<Either<Failure, List<Camp>>> getCamps() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteFreizeiten = await remoteDataSource.getFreizeiten();
        await localDatasource.cacheCamps(remoteFreizeiten);
        final camps = await localDatasource.getCachedCamps();
        _setPrefrenceCachedFreizeiten(camps);
        return Right(camps);
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        List<Camp> camps = await localDatasource.getCachedCamps();
        _setPrefrenceCachedFreizeiten(camps);
        return Right(camps);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  //Lade bestimmte Freizeit aus Cache
  @override
  Future<Either<Failure, Camp>> getCamp(int id) async {
    try {
      List<Camp> cachedCamps = await localDatasource.getCachedCamps();
      for (var value in cachedCamps) {
        if (value.id == id) {
          return Right(value);
        }
      }
      return Left(CacheFailure());
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
