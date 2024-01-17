import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/Repository.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class ReadOnlyService<T extends Equatable, K> {
  final Repository<T, K> repository;
  final String boxKey;

  ReadOnlyService({required this.boxKey, required this.repository});

  Future<Either<Failure, T>> getElement({K? id}) async {
    final Box box = await Hive.openBox(boxKey);
    final Either<Failure, T> result = await repository.getElement(boxKey, id!);
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }

  Future<Either<Failure, List<T>>> getAllElements() async {
    final Box box = await Hive.openBox(boxKey);
    final Either<Failure, List<T>> result =
        await repository.getAllElements(boxKey);
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }
}
