import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/bak_repository.dart';
import 'package:eje/services/usecase.dart';
import 'package:hive/hive.dart';

class GetBAK implements Service<List<BAKler>> {
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
