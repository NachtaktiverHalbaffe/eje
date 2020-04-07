import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/eje/bak/data/datasources/bak_local_datasource.dart';
import 'package:eje/pages/eje/bak/data/datasources/bak_remote_datasource.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/bak/domain/repositories/bak_repository.dart';
import 'package:meta/meta.dart';

class BAKRepositoryImpl implements BAKRepository {
  final BAKRemoteDatasource remoteDataSource;
  final BAKLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  BAKRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<BAKler>>> getBAK() async{
    /*if (await networkInfo.isConnected) {
      try {
        final remoteBAK = await remoteDataSource.getBAK();
        localDatasource.cacheBAK(remoteBAK);
        return Right(remoteBAK);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else*/
    print("GetCachedBAK");
    return Right(await localDatasource.getCachedBAK());
  }

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, BAKler>> getBAKler(String name) async{
    try {
      List<BAKler> _bak =
      await localDatasource.getCachedBAK();
      for (var value in _bak) {
        if (value.name == name) {
          return Right(value);
        }
      }
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

