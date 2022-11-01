import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/datasources/employees_local_datasource.dart';
import 'package:eje/pages/eje/hauptamtlichen/data/datasources/employees_remote_datasource.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/employee.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/repositories/employees_repository.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final EmployeesRemoteDatasource remoteDataSource;
  final EmployeesLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  EmployeesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDatasource,
    required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<Employee>>> getEmployees() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteHauptamtliche = await remoteDataSource.getEmployees();
        await localDatasource.cacheEmployees(remoteHauptamtliche);
        return Right(await localDatasource.getCachedEmployees());
      } on ServerException {
        return Left(ServerFailure());
      } on ConnectionException {
        return Left(ConnectionFailure());
      }
    } else {
      try {
        return Right(await localDatasource.getCachedEmployees());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Employee>> getEmployee(String name) async {
    try {
      List<Employee> hauptamtliche = await localDatasource.getCachedEmployees();
      for (var value in hauptamtliche) {
        if (value.name == name) {
          return Right(value);
        }
      }
      return Left(CacheFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
