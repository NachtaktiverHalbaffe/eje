import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';

abstract class Service<Type> {
  Future<Either<Failure, Type>> call();
}
