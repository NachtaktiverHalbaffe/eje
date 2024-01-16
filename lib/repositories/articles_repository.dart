import 'package:dartz/dartz.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/failures.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, Article>> getArticle(
      String url); // Einen Artikel laden
  Future<Either<Failure, List<Article>>> getArticles(
      String url); // Alle Artike laden
}
