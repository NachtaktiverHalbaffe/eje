import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/repositories/articles_repository.dart';
import 'package:hive/hive.dart';

class ArticleService {
  final ArticlesRepository repository;

  ArticleService(this.repository);

  Future<Either<Failure, Article>> getArticle({String? url}) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.articlesBox);
    final result = await repository.getArticle(url!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }

  Future<Either<Failure, List<Article>>> getArticles({String? url}) async {
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
