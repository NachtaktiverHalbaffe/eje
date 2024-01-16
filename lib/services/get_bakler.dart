import 'package:dartz/dartz.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/bak_repository.dart';
import 'package:eje/services/usecase.dart';
import 'package:hive/hive.dart';

import '../../../../../app_config.dart';

class GetBAKler implements Service<BAKler> {
  final BAKRepository repository;

  GetBAKler(this.repository);

  @override
  Future<Either<Failure, BAKler>> call({
    String? name,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.bakBox);
    final result = await repository.getBAKler(name!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }
}
