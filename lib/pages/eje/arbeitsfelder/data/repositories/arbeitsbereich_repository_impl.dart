import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/eje/arbeitsfelder/data/datasources/arbeitsbereich_local_datasource.dart';
import 'package:eje/pages/eje/arbeitsfelder/data/datasources/arbeitsbereich_remote_datasource.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/repositories/arbeitsbereich_repository.dart';
import 'package:meta/meta.dart';

class ArbeitsbereichRepositoryImpl implements ArbeitsbereichRepository {
  final ArbeitsbereichRemoteDatasource remoteDataSource;
  final ArbeitsbereicheLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  ArbeitsbereichRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<Arbeitsbereich>>> getArbeitsbereiche() async {
    /*if (await networkInfo.isConnected) {
      try {
        final remoteArbeitsbereich= await remoteDataSource.getArtbeitsbereiche();
        localDatasource.cacheBAK(remoteArbeitsbereich);
        return Right(await localDatasource.getCachedArbeitsbereiche());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else */
    return Right(await localDatasource.getCachedArbeitsbereiche());
  }

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Arbeitsbereich>> getArbeitsbereich(
      String arbeitsfeld) async {
    try {
      List<Arbeitsbereich> _arbeitsfeld =
          localDatasource.getCachedArbeitsbereiche();
      for (var value in _arbeitsfeld) {
        if (value.arbeitsfeld == arbeitsfeld) {
          return Right(value);
        }
      }
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
