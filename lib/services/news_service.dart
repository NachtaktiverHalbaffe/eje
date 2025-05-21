import 'package:dartz/dartz.dart';
import 'package:eje/models/article.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/news.dart';
import 'package:eje/repositories/cached_remote_repository.dart';
import 'package:eje/repositories/cached_remote_single_element_repository.dart';

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
