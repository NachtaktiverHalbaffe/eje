import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/repositories/arbeitsbereich_repository.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

class GetArbeitsbereiche implements UseCase<List<Arbeitsbereich>> {
  final ArbeitsbereichRepository repository;

  GetArbeitsbereiche({@required this.repository});

  @override
  Future<Either<Failure, List<Arbeitsbereich>>> call() async {
    Box _box = await Hive.openBox('Arbeitsbereiche');
    final result = await repository.getArbeitsbereiche();
    await _box.compact();
    await _box.close();
    return result;
  }
}
