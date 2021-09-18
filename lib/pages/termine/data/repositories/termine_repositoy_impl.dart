import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/termine/data/datasources/termine_local_datasource.dart';
import 'package:eje/pages/termine/data/datasources/termine_remote_datasource.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:eje/pages/termine/domain/entities/errorTermin.dart';
import 'package:eje/pages/termine/domain/repsoitories/termin_repositoy.dart';
import 'package:meta/meta.dart';

class TermineRepositoryImpl implements TerminRepository {
  final TermineRemoteDatasource remoteDataSource;
  final TermineLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  TermineRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<Termin>>> getTermine() async {
    /*if (await networkInfo.isConnected) {
      try {
        final remoteTermine= await remoteDataSource.getTermine();
        localDatasource.cacheTermine(remoteTermine);
        return Right(await localDatasource.getCachedTermine());
      } on ServerException {
        return Right([getErrorTermin()]);
      }
    } else */
    return Right(await localDatasource.getCachedTermine());
  }

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Termin>> getTermin(
      String veranstaltung, String dateTime) async {
    try {
      List<Termin> _termin = await localDatasource.getCachedTermine();
      for (var value in _termin) {
        if (value.veranstaltung == veranstaltung && value.datum == dateTime) {
          return Right(value);
        }
      }
      return Right(getErrorTermin());
    } on CacheException {
      return Right(getErrorTermin());
    }
  }
}
