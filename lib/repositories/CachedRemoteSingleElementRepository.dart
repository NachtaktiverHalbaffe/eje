import 'package:dartz/dartz.dart';
import 'package:eje/datasources/LocalDataSource.dart';
import 'package:eje/datasources/RemoteDataSource.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/Repository.dart';
import 'package:eje/utils/network_info.dart';
import 'package:equatable/equatable.dart';

class CachedRemoteSingleElementRepository<T extends Equatable, K>
    implements Repository<T, K> {
  final RemoteDataSource<T, K> remoteDatasource;
  final LocalDataSource<T, K> localDatasource;
  final NetworkInfo networkInfo;

  CachedRemoteSingleElementRepository(
      {required this.remoteDatasource,
      required this.localDatasource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<T>>> getAllElement(String boxKey) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, T>> getElement(
      String boxKey, K elementId, String idKey) async {
    if (await networkInfo.isConnected) {
      try {
        final T remoteElement = await remoteDatasource.getElement(elementId);
        await localDatasource.cacheElement(boxKey, remoteElement);
        return Right(remoteElement);
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        T cachedElements =
            await localDatasource.getElement(boxKey, elementId, idKey);
        return Right(cachedElements);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
