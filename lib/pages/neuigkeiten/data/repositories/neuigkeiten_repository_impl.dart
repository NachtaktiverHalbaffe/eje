import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_local_datasource.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/neuigkeiten_repository.dart';

class NeuigkeitenRepositoryImpl implements NeuigkeitenRespository {
  final NeuigkeitenRemoteDatasource remoteDataSource;
  final NeuigkeitenLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  NeuigkeitenRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, Neuigkeit>> getNeuigkeit(String titel) {
    // TODO: implement getNeuigkeit
    return null;
  }

  @override
  Future<Either<Failure, List<Neuigkeit>>> getNeuigkeiten() {
    // TODO: implement getNeuigkeiten
    return null;
  }
}
