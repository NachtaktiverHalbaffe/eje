import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/news.dart';
import 'package:eje/repositories/CachedRemoteRepository.dart';
import 'package:eje/repositories/CachedRemoteSingleElementRepository.dart';

class NewsService {
  final CachedRemoteRepository<News, String> repository;
  final CachedRemoteSingleElementRepository<Article, String> articleRepository;

  NewsService({required this.articleRepository, required this.repository});

  Future<Either<Failure, Article>> getSingleNews({String? url}) async {
    final article = await articleRepository.getElement(url!);

    return article;
  }

  Future<Either<Failure, List<News>>> getNews() async {
    final result = await repository.getAllElements();

    return result;
  }

  Future<Either<Failure, List<News>>> getCachedNews() async {
    final result = await repository.getAllCachedElements();

    return result;
  }
}
