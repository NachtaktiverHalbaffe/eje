import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/eje/arbeitsfelder/data/datasources/arbeitsbereich_local_datasource.dart';
import 'package:eje/pages/eje/arbeitsfelder/data/datasources/arbeitsbereich_remote_datasource.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/field_of_work.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/repositories/field_of_work_repository.dart';

class ArbeitsbereichRepositoryImpl implements FieldOfWorkRepository {
  final ArbeitsbereichRemoteDatasource remoteDataSource;
  final ArbeitsbereicheLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  ArbeitsbereichRepositoryImpl({
    required this.remoteDataSource,
    required this.localDatasource,
    required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<FieldOfWork>>> getFieldsOfWork() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArbeitsbereich =
            await remoteDataSource.getArtbeitsbereiche();
        await localDatasource.cacheBAK(remoteArbeitsbereich);
        return Right(await localDatasource.getCachedArbeitsbereiche());
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        return Right(await localDatasource.getCachedArbeitsbereiche());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  //Lade bestimmten Artikel aus Cache, inaktiv da durch getArticle ersetzt
  @override
  Future<Either<Failure, FieldOfWork>> getFieldOfWork(
      String arbeitsfeld) async {
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      List<FieldOfWork> _arbeitsfeld =
          await localDatasource.getCachedArbeitsbereiche();
      for (var value in _arbeitsfeld) {
        if (value.name == arbeitsfeld) {
          return Right(value);
        }
      }
      return Left(CacheFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
