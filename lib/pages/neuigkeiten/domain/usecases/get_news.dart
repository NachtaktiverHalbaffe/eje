import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/news.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/news_repository.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class GetNews implements UseCase<List<News>> {
  final NewsRepository repository;

  GetNews(this.repository);

  @override
  Future<Either<Failure, List<News>>> call() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = await Hive.openBox(appConfig.newsBox);
    final result = await repository.getNews();
    if (_box.isOpen) {
      await _box.compact();
      // await _box.close();
    }
    return result;
  }
}
