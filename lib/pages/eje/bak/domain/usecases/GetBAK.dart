
import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/bak/domain/repositories/bak_repository.dart';
import 'package:meta/meta.dart';

class GetBAK implements UseCase< List<BAKler>>{
  final BAKRepository repository;

  GetBAK({@required this.repository});

  @override
  Future<Either<Failure, List<BAKler>>> call() async{ return await repository.getBAK();
  }
}