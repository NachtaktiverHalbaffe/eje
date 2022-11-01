import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/news_repository.dart';
import 'package:hive/hive.dart';

class GetSingleNews implements UseCase<Article> {
  final NewsRepository repository;

  GetSingleNews(this.repository);

  @override
  Future<Either<Failure, Article>> call({
    String? titel,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.newsBox);
    final Box box2 = await Hive.openBox(appConfig.articlesBox);
    final result = await repository.getSingleNews(titel!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    if (box2.isOpen) {
      await box2.compact();
      // await _box2.close();
    }
    return result;
  }
}
