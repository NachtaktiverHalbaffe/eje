import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/datasources/LocalDataSource.dart';
import 'package:eje/datasources/bak_remote_datasource.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/utils/network_info.dart';

class BAKRepository {
  final BAKRemoteDatasource remoteDataSource;
  final LocalDataSource<BAKler, String> localDatasource;
  final NetworkInfo networkInfo;

  BAKRepository(
      {required this.remoteDataSource,
      required this.localDatasource,
      required this.networkInfo});

  Future<Either<Failure, List<BAKler>>> getBAK() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    if (await networkInfo.isConnected) {
      try {
        final remoteBAK = await remoteDataSource.getBAK();
        await localDatasource.cacheElements(appConfig.bakBox, remoteBAK);
        return Right(await localDatasource.getAllElements(appConfig.bakBox));
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        return Right(await localDatasource.getAllElements(appConfig.bakBox));
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  //Lade bestimmten Artikel aus Cache
  Future<Either<Failure, BAKler>> getBAKler(String name) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    try {
      BAKler bakler =
          await localDatasource.getElement(appConfig.bakBox, name, "name");
      return (Right(bakler));
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
