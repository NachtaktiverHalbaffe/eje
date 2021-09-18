import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/datasources/hauptamtliche_local_datasource.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/datasources/hauptamtliche_remote_datasource.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/errorHauptamtlicher.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/repositories/hauptamtliche_repository.dart';
import 'package:meta/meta.dart';

class HauptamtlicheRepositoryImpl implements HauptamtlicheRepository {
  final HauptamtlicheRemoteDatasource remoteDataSource;
  final HauptamtlicheLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  HauptamtlicheRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<Hauptamtlicher>>> getHauptamtliche() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteHauptamtliche = await remoteDataSource.getHauptamliche();
        localDatasource.cacheHauptamtliche(remoteHauptamtliche);
        return Right(await localDatasource.getCachedHauptamtliche());
      } on ServerException {
        return Right([getErrorHauptamtlicher()]);
      }
    } else
      return Right(await localDatasource.getCachedHauptamtliche());
  }

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Hauptamtlicher>> getHauptamtlicher(String name) async {
    try {
      List<Hauptamtlicher> _hauptamtliche =
          await localDatasource.getCachedHauptamtliche();
      for (var value in _hauptamtliche) {
        if (value.name == name) {
          return Right(value);
        }
      }
      return Right(getErrorHauptamtlicher());
    } on CacheException {
      return Right(getErrorHauptamtlicher());
    }
  }
}
