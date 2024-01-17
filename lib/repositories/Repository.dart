import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:equatable/equatable.dart';

abstract class Repository<T extends Equatable, K> {
  Future<Either<Failure, List<T>>> getAllElement(String boxKey);
  Future<Either<Failure, T>> getElement(
      String boxKey, K elementId, String idKey);
}
