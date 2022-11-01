import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/repositories/articles_repository.dart';
import 'package:hive/hive.dart';

class GetArticle implements UseCase<Article> {
  final ArticlesRepository repository;

  GetArticle(this.repository);

  @override
  Future<Either<Failure, Article>> call({
    String? url,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.articlesBox);
    final result = await repository.getArticle(url!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }
}
