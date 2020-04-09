import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/freizeiten/domain/repositories/freizeit_repository.dart';
import 'package:meta/meta.dart';

class GetFreizeiten implements UseCase< List<Freizeit>>{
  final FreizeitRepository repository;

  GetFreizeiten({@required this.repository});

  @override
  Future<Either<Failure, List<Freizeit>>> call() async{ return await repository.getFreizeiten();
  }
}