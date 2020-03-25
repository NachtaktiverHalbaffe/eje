import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';

abstract class UseCase<Type> {
  Future<Either<Failure, Type>> call();
}
