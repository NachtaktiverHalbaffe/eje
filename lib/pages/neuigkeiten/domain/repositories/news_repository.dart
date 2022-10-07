import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/news.dart';

abstract class NewsRepository {
  Future<Either<Failure, Article>> getSingleNews(
      String titel); // Einen Artikel laden
  Future<Either<Failure, List<News>>> getNews(); // Alle Artike laden
}
