import 'package:dartz/dartz.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/news.dart';

abstract class NewsRepository {
  Future<Either<Failure, Article>> getSingleNews(
      String titel); // Einen Artikel laden
  Future<Either<Failure, List<News>>> getNews(); // Alle Artike laden
}
