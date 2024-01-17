import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/news.dart';
import 'package:eje/repositories/CachedRemoteRepository.dart';
import 'package:eje/repositories/CachedRemoteSingleElementRepository.dart';
import 'package:hive/hive.dart';

class NewsService {
  final CachedRemoteRepository<News, String> repository;
  final CachedRemoteSingleElementRepository<Article, String> articleRepository;

  NewsService({required this.articleRepository, required this.repository});

  Future<Either<Failure, Article>> getSingleNews({String? url}) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.articlesBox);
    final article =
        await articleRepository.getElement(appConfig.articlesBox, url!, "url");
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return article;
  }

  Future<Either<Failure, List<News>>> getNews() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.newsBox);
    final result = await repository.getAllElement(appConfig.newsBox);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }
}
