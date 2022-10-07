import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/termine/data/datasources/events_local_datasource.dart';
import 'package:eje/pages/termine/data/datasources/events_remote_datasource.dart';
import 'package:eje/pages/termine/domain/entities/Event.dart';
import 'package:eje/pages/termine/domain/repsoitories/events_repository.dart';
import 'package:meta/meta.dart';

class EventsRepositoryImpl implements EventsRepository {
  final TermineRemoteDatasource remoteDataSource;
  final EventLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  EventsRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<Event>>> getEvents() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTermine = await remoteDataSource.getTermine();
        await localDatasource.cacheEvents(remoteTermine);
        return Right(await localDatasource.getCachedEvents());
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        return Right(await localDatasource.getCachedEvents());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Event>> getEvent(int id) async {
    try {
      List<Event> _termin = await localDatasource.getCachedEvents();
      for (var value in _termin) {
        if (value.id == id) {
          return Right(value);
        }
      }
      return Left(CacheFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
