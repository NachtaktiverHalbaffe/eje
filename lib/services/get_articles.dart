import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/services/usecase.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/repositories/articles_repository.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class GetArticles implements Service<List<Article>> {
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
