import 'package:dartz/dartz.dart';
import 'package:eje/datasources/LocalDataSource.dart';
import 'package:eje/datasources/RemoteDataSource.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/Repository.dart';
import 'package:eje/utils/network_info.dart';
import 'package:equatable/equatable.dart';

class CachedRemoteRepository<T extends Equatable, K>
    implements Repository<T, K> {
  final RemoteDataSource<T, K> remoteDatasource;
  final LocalDataSource<T, K> localDatasource;
  final String idKey;
  final NetworkInfo networkInfo;
  final Comparator? sortStrategy;

  CachedRemoteRepository(
      {required this.remoteDatasource,
      required this.localDatasource,
      required this.networkInfo,
      required this.idKey,
      this.sortStrategy});

  @override
  Future<Either<Failure, List<T>>> getAllElements(String boxKey) async {
    if (await networkInfo.isConnected) {
      try {
        List<T> remoteElements = await remoteDatasource.getAllElements();
        await localDatasource.cacheElements(boxKey, remoteElements);
        if (sortStrategy != null) {
          remoteElements.sort(sortStrategy);
        }
        return Right(remoteElements);
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        List<T> cachedElements = await localDatasource.getAllElements(boxKey);
        return Right(cachedElements);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, T>> getElement(String boxKey, K elementId) async {
    try {
      T element = await localDatasource.getElement(boxKey, elementId, idKey);
      return Right(element);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
