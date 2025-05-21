import 'package:dartz/dartz.dart';
import 'package:eje/datasources/local_data_source.dart';
import 'package:eje/datasources/remote_data_source.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/repository.dart';
import 'package:eje/utils/network_info.dart';
import 'package:equatable/equatable.dart';

class CachedRemoteRepository<T extends Equatable, K>
    implements Repository<T, K> {
  final RemoteDataSource<T, K> remoteDatasource;
  final LocalDataSource<T, K> localDatasource;
  final NetworkInfo networkInfo;
  final Comparator? sortStrategy;
  final bool? reverse;

  CachedRemoteRepository(
      {required this.remoteDatasource,
      required this.localDatasource,
      required this.networkInfo,
      this.reverse = false,
      this.sortStrategy});

  @override
  Future<Either<Failure, List<T>>> getAllElements() async {
    if (await networkInfo.isConnected) {
      try {
        List<T> remoteElements = await remoteDatasource.getAllElements();
        if (sortStrategy != null) {
          remoteElements.sort(sortStrategy);
        }
        if (reverse!) {
          remoteElements = remoteElements.reversed.toList();
        }
        await localDatasource.cacheElements(remoteElements);

        return Right(remoteElements);
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  Future<Either<Failure, List<T>>> getAllCachedElements() async {
    try {
      List<T> cachedElements = await localDatasource.getAllElements();
      return Right(cachedElements);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, T>> getElement(K elementId) async {
    try {
      T element = await localDatasource.getElement(elementId);
      return Right(element);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
