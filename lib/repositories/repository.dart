import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:equatable/equatable.dart';

abstract class Repository<T extends Equatable, K> {
  Future<Either<Failure, List<T>>> getAllElements();
  Future<Either<Failure, T>> getElement(K elementId);
}
