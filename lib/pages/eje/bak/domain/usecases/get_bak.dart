import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/bak/domain/repositories/bak_repository.dart';
import 'package:hive/hive.dart';

class GetBAK implements UseCase<List<BAKler>> {
  final BAKRepository repository;

  GetBAK({required this.repository});

  @override
  Future<Either<Failure, List<BAKler>>> call() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.bakBox);
    final result = await repository.getBAK();
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }
}
