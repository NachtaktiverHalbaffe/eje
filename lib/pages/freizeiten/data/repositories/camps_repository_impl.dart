import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/freizeiten/data/datasources/camps_local_datasource.dart';
import 'package:eje/pages/freizeiten/data/datasources/camps_remote_datasource.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/freizeiten/domain/entities/errorCamp.dart';
import 'package:eje/pages/freizeiten/domain/repositories/camp_repository.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';

class CampRepositoryImpl implements CampRepository {
  final CampsRemoteDatasource remoteDataSource;
  final CampsLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  CampRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDatasource,
    @required this.networkInfo,
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
      }
    } else {
      List<Camp> camps = await localDatasource.getCachedCamps();
      _setPrefrenceCachedFreizeiten(camps);
      return Right(camps);
    }
  }

  //Lade bestimmte Freizeit aus Cache
  @override
  Future<Either<Failure, Camp>> getCamp(Camp camp) async {
    try {
      List<Camp> cachedCamps = await localDatasource.getCachedCamps();
      for (var value in cachedCamps) {
        if (value.name == camp.name) {
          return Right(value);
        }
      }
      return Right(getErrorCamp());
    } on CacheException {
      return Right(getErrorCamp());
    }
  }

  void _setPrefrenceCachedFreizeiten(List<Camp> camps) {
    List<String> freizeitenNamen = List.empty(growable: true);
    camps.forEach((element) {
      freizeitenNamen.add(element.name);
    });
    GetStorage().write("cached_freizeiten", freizeitenNamen);
  }
}