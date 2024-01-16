import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/datasources/LocalDataSource.dart';
import 'package:eje/datasources/employees_remote_datasource.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/utils/network_info.dart';

class EmployeesRepository {
  final EmployeesRemoteDatasource remoteDataSource;
  final LocalDataSource<Employee, String> localDatasource;
  final NetworkInfo networkInfo;

  EmployeesRepository(
      {required this.remoteDataSource,
      required this.localDatasource,
      required this.networkInfo});

  //Lade Artikel aus den Internet herunter
  Future<Either<Failure, List<Employee>>> getEmployees() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    if (await networkInfo.isConnected) {
      try {
        final remoteHauptamtliche = await remoteDataSource.getEmployees();
        await localDatasource.cacheElements(
            appConfig.employeesBox, remoteHauptamtliche);
        return Right(
            await localDatasource.getAllElements(appConfig.employeesBox));
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        return Right(
            await localDatasource.getAllElements(appConfig.employeesBox));
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  //Lade bestimmten Artikel aus Cache
  Future<Either<Failure, Employee>> getEmployee(String name) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    try {
      Employee hauptamtlicher = await localDatasource.getElement(
          appConfig.employeesBox, name, "name");
      return Right(hauptamtlicher);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
