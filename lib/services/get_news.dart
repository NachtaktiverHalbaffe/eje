import 'package:dartz/dartz.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/news.dart';
import 'package:eje/services/usecase.dart';
import 'package:eje/repositories/news_repository.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class GetNews implements Service<List<News>> {
  final NewsRepository repository;

  GetNews(this.repository);

  @override
  Future<Either<Failure, List<News>>> call() async {
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
