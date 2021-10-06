import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/articles/domain/entity/article.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/news_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GetSingleNews implements UseCase<Article> {
  final NewsRepository repository;

  GetSingleNews(this.repository);

  @override
  Future<Either<Failure, Article>> call({
    @required String titel,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = await Hive.openBox(appConfig.newsBox);
    final Box _box2 = await Hive.openBox(appConfig.articlesBox);
    final result = await repository.getSingleNews(titel);
    if (_box.isOpen) {
      await _box.compact();
      // await _box.close();
    }
    if (_box2.isOpen) {
      await _box2.compact();
      // await _box2.close();
    }
    return result;
  }
}
