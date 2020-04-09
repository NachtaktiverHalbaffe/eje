import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:eje/pages/termine/domain/repsoitories/termin_repositoy.dart';
import 'package:meta/meta.dart';

class GetTermine implements UseCase< List<Termin>>{
  final TerminRepository repository;

  GetTermine({@required this.repository});

  @override
  Future<Either<Failure, List<Termin>>> call() async{ return await repository.getTermine();
  }
}