import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/articles/domain/entity/article.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, Article>> getArticle(
      String url); // Einen Artikel laden
  Future<Either<Failure, List<Article>>> getArticles(
      String url); // Alle Artike laden
}
