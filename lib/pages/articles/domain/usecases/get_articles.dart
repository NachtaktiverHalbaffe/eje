import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/repositories/articles_repository.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class GetArticles implements UseCase<List<Article>> {
  final ArticlesRepository repository;

  GetArticles(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call({
    String? url,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.articlesBox);
    final result = await repository.getArticles(url!);
    if (box.isOpen) {
      await box.compact();
      await box.close();
    }
    return result;
  }
}
