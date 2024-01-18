import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/news.dart';
import 'package:eje/repositories/Repository.dart';
import 'package:hive/hive.dart';

class NewsService {
  final Repository<News, String> repository;
  final Repository<Article, String> articleRepository;

  NewsService({required this.articleRepository, required this.repository});

  Future<Either<Failure, Article>> getSingleNews({String? url}) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.box(name: appConfig.articlesBox);

    final article =
        await articleRepository.getElement(appConfig.articlesBox, url!);

    if (box.isOpen) {
      box.close();
    }
    return article;
  }

  Future<Either<Failure, List<News>>> getNews() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.box(name: appConfig.newsBox);
    final result = await repository.getAllElements(appConfig.newsBox);
    if (box.isOpen) {
      box.close();
    }
    return result;
  }
}
