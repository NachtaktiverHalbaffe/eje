import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/cached_remote_repository.dart';
import 'package:equatable/equatable.dart';

class ReadOnlyCachedService<T extends Equatable, K> {
  final CachedRemoteRepository<T, K> repository;

  ReadOnlyCachedService({required this.repository});

  Future<Either<Failure, T>> getElement({required K id}) async {
    final Either<Failure, T> result = await repository.getElement(id);
    return result;
  }

  Future<Either<Failure, List<T>>> getAllElements() async {
    final Either<Failure, List<T>> result = await repository.getAllElements();
    return result;
  }

  Future<Either<Failure, List<T>>> getAllCachedElements() async {
    final Either<Failure, List<T>> result =
        await repository.getAllCachedElements();

    return result;
  }
}
