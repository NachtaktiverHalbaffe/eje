import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/CachedRemoteSingleElementRepository.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class ReadOnlySingleElementService<T extends Equatable, K> {
  final CachedRemoteSingleElementRepository<T, K> repository;
  final String boxKey;

  ReadOnlySingleElementService(
      {required this.boxKey, required this.repository});

  Future<Either<Failure, T>> getElement({required K id}) async {
    final Box box = await Hive.openBox(boxKey);
    final result = await repository.getElement(boxKey, id);
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }

  Future<Either<Failure, T>> getCachedElement({required K id}) async {
    final Box box = await Hive.openBox(boxKey);
    final result = await repository.getCachedElement(boxKey, id);
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }
}
