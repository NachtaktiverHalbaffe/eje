import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:meta/meta.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_local_datasource.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/neuigkeiten_repository.dart';

class NeuigkeitenRepositoryImpl implements NeuigkeitenRepository {
  final NeuigkeitenRemoteDatasource remoteDataSource;
  final NeuigkeitenLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  NeuigkeitenRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Neuigkeit>> getNeuigkeit(String titel) async {
    try {
      List<Neuigkeit> _neuigkeiten =
      await localDatasource.getCachedNeuigkeiten();
      for (var value in _neuigkeiten) {
        if (value.titel == titel) {
          return Right(value);
        }
      }
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<Neuigkeit>>> getNeuigkeiten() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNeuigkeit = await remoteDataSource.getNeuigkeiten();
        localDatasource.cacheNeuigkeiten(remoteNeuigkeit);
        return Right(remoteNeuigkeit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Right(await localDatasource.getCachedNeuigkeiten());
    }
  }
}
