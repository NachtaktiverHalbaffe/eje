import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/datasources/LocalDataSource.dart';
import 'package:eje/datasources/events_remote_datasource.dart';
import 'package:eje/models/Event.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/utils/network_info.dart';

class EventsRepository {
  final TermineRemoteDatasource remoteDataSource;
  final LocalDataSource<Event, int> localDatasource;
  final NetworkInfo networkInfo;

  EventsRepository(
      {required this.remoteDataSource,
      required this.localDatasource,
      required this.networkInfo});

  Future<Either<Failure, List<Event>>> getEvents() async {
    final AppConfig appConfig = await AppConfig.loadConfig();

    if (await networkInfo.isConnected) {
      try {
        final remoteTermine = await remoteDataSource.getTermine();
        await localDatasource.cacheElements(appConfig.eventsBox, remoteTermine);
        return Right(await localDatasource.getAllElements(appConfig.eventsBox));
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        return Right(await localDatasource.getAllElements(appConfig.eventsBox));
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  //Lade bestimmten Artikel aus Cache
  Future<Either<Failure, Event>> getEvent(int id) async {
    final AppConfig appConfig = await AppConfig.loadConfig();

    try {
      Event event =
          await localDatasource.getElement(appConfig.eventsBox, id, "id");
      return Right(event);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
