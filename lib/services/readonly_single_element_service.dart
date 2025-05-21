import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/cached_remote_single_element_repository.dart';
import 'package:equatable/equatable.dart';

class ReadOnlySingleElementService<T extends Equatable, K> {
  final CachedRemoteSingleElementRepository<T, K> repository;

  ReadOnlySingleElementService({required this.repository});

  Future<Either<Failure, T>> getElement({required K id}) async {
    final result = await repository.getElement(id);

    return result;
  }

  Future<Either<Failure, T>> getCachedElement({required K id}) async {
    final result = await repository.getCachedElement(id);

    return result;
  }
}
