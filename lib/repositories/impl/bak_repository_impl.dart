import 'package:dartz/dartz.dart';
import 'package:eje/datasources/bak_local_datasource.dart';
import 'package:eje/datasources/bak_remote_datasource.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/bak_repository.dart';
import 'package:eje/utils/network_info.dart';

class BAKRepositoryImpl implements BAKRepository {
  final BAKRemoteDatasource remoteDataSource;
  final BAKLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  BAKRepositoryImpl({
    required this.remoteDataSource,
    required this.localDatasource,
    required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<BAKler>>> getBAK() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBAK = await remoteDataSource.getBAK();
        await localDatasource.cacheBAK(remoteBAK);
        return Right(await localDatasource.getCachedBAK());
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        return Right(await localDatasource.getCachedBAK());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, BAKler>> getBAKler(String name) async {
    try {
      List<BAKler> bak = await localDatasource.getCachedBAK();
      for (var value in bak) {
        if (value.name == name) {
          return Right(value);
        }
      }
      return Left(CacheFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
