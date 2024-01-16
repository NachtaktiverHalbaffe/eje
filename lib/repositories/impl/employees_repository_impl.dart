import 'package:dartz/dartz.dart';
import 'package:eje/datasources/employees_local_datasource.dart';
import 'package:eje/datasources/employees_remote_datasource.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/employees_repository.dart';
import 'package:eje/utils/network_info.dart';

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
