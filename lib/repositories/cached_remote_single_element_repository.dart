import 'package:dartz/dartz.dart';
import 'package:eje/datasources/local_data_source.dart';
import 'package:eje/datasources/remote_data_source.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/repository.dart';
import 'package:eje/utils/network_info.dart';
import 'package:equatable/equatable.dart';

class CachedRemoteSingleElementRepository<T extends Equatable, K>
    implements Repository<T, K> {
  final RemoteDataSource<T, K> remoteDatasource;
  final LocalDataSource<T, K> localDatasource;
  final NetworkInfo networkInfo;

  CachedRemoteSingleElementRepository({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<T>>> getAllElements() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, T>> getElement(K elementId) async {
    if (await networkInfo.isConnected) {
      try {
        final T remoteElement = await remoteDatasource.getElement(elementId);
        await localDatasource.cacheElement(remoteElement);
        return Right(remoteElement);
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  Future<Either<Failure, T>> getCachedElement(K elementId) async {
    try {
      T cachedElements = await localDatasource.getElement(elementId);
      return Right(cachedElements);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
