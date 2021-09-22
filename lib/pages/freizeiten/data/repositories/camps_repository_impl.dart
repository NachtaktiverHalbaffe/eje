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
    final prefs = GetStorage();
    /*if (await networkInfo.isConnected) {
      try {
        final remoteFreizeiten= await remoteDataSource.getFreizeiten();
        localDatasource.cacheFreizeiten(remoteFreizeiten);
        return Right(await localDatasource.getCachedFreizeiten());
      } on ServerException {
        return Right([getErrorFreizeit()]);;
      }
    } else */
    List<String> freizeitenNamen = List.empty(growable: true);
    List<Camp> _freizeiten = await localDatasource.getCachedCamps();
    _freizeiten.forEach((element) {
      freizeitenNamen.add(element.name);
    });
    prefs.write("cached_freizeiten", freizeitenNamen);
    return Right(await localDatasource.getCachedCamps());
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
}
