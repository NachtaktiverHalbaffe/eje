import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/news.dart';
import 'package:eje/repositories/news_repository.dart';
import 'package:hive/hive.dart';

class NewsService {
  final NewsRepository repository;

  NewsService({required this.repository});

  @override
  Future<Either<Failure, Article>> getSingleNews({String? titel}) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.newsBox);
    final Box box2 = await Hive.openBox(appConfig.articlesBox);
    final result = await repository.getSingleNews(titel!);
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    if (box2.isOpen) {
      await box2.compact();
      // await _box2.close();
    }
    return result;
  }

  Future<Either<Failure, List<News>>> getNews() async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = await Hive.openBox(appConfig.newsBox);
    final result = await repository.getNews();
    if (box.isOpen) {
      await box.compact();
      // await _box.close();
    }
    return result;
  }
}
