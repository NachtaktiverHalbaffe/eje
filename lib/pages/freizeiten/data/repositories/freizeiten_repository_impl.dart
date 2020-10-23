import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/freizeiten/data/datasources/freizeiten_local_datasource.dart';
import 'package:eje/pages/freizeiten/data/datasources/freizeiten_remote_datasource.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/freizeiten/domain/entities/errorFreizeit.dart';
import 'package:eje/pages/freizeiten/domain/repositories/freizeit_repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreizeitenRepositoryImpl implements FreizeitRepository {
  final FreizeitenRemoteDatasource remoteDataSource;
  final FreizeitenLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  FreizeitenRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  //Lade Freizeiten aus den Internet herunter
  @override
  Future<Either<Failure, List<Freizeit>>> getFreizeiten() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /*if (await networkInfo.isConnected) {
      try {
        final remoteFreizeiten= await remoteDataSource.getFreizeiten();
        localDatasource.cacheFreizeiten(remoteFreizeiten);
        return Right(await localDatasource.getCachedFreizeiten());
      } on ServerException {
        return Right([getErrorFreizeit()]);;
      }
    } else */
    prefs.setInt(
        "freizeiten_length", localDatasource.getCachedFreizeiten().length);
    return Right(localDatasource.getCachedFreizeiten());
  }

  //Lade bestimmte Freizeit aus Cache
  @override
  Future<Either<Failure, Freizeit>> getFreizeit(Freizeit freizeit) async {
    try {
      List<Freizeit> _freizeit = localDatasource.getCachedFreizeiten();
      for (var value in _freizeit) {
        if (value.freizeit == freizeit.freizeit) {
          return Right(value);
        }
      }
    } on CacheException {
      return Right(getErrorFreizeit());
    }
  }
}
