import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/datasources/LocalDataSource.dart';
import 'package:eje/datasources/arbeitsbereich_remote_datasource.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:eje/utils/network_info.dart';

class FieldOfWorkRepository {
  final ArbeitsbereichRemoteDatasource remoteDataSource;
  final LocalDataSource<FieldOfWork, String> localDatasource;
  final NetworkInfo networkInfo;

  FieldOfWorkRepository(
      {required this.remoteDataSource,
      required this.localDatasource,
      required this.networkInfo});

  Future<Either<Failure, List<FieldOfWork>>> getFieldsOfWork() async {
    final AppConfig appConfig = await AppConfig.loadConfig();

    if (await networkInfo.isConnected) {
      try {
        final remoteArbeitsbereich =
            await remoteDataSource.getArtbeitsbereiche();
        await localDatasource.cacheElements(
            appConfig.fieldOfWorkBox, remoteArbeitsbereich);
        return Right(
            await localDatasource.getAllElements(appConfig.fieldOfWorkBox));
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        return Right(
            await localDatasource.getAllElements(appConfig.fieldOfWorkBox));
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  //Lade bestimmten Artikel aus Cache, inaktiv da durch getArticle ersetzt
  Future<Either<Failure, FieldOfWork>> getFieldOfWork(
      String arbeitsfeld) async {
    final AppConfig appConfig = await AppConfig.loadConfig();

    try {
      // ignore: no_leading_underscores_for_local_identifiers
      FieldOfWork fow = await localDatasource.getElement(
          appConfig.fieldOfWorkBox, arbeitsfeld, "name");
      return Right(fow);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
