import 'package:dartz/dartz.dart';
import 'package:eje/datasources/events_local_datasource.dart';
import 'package:eje/datasources/events_remote_datasource.dart';
import 'package:eje/models/Event.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/events_repository.dart';
import 'package:eje/utils/network_info.dart';

class EventsRepositoryImpl implements EventsRepository {
  final TermineRemoteDatasource remoteDataSource;
  final EventLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  EventsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDatasource,
    required this.networkInfo,
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
      List<Event> termin = await localDatasource.getCachedEvents();
      for (var value in termin) {
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
