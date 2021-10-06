import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/articles/domain/entity/article.dart';
import 'package:eje/pages/articles/domain/repositories/articles_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class GetArticles implements UseCase<List<Article>> {
  final ArticlesRepository repository;

  GetArticles(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call({
    @required String url,
  }) async {
    final AppConfig appConfig = await AppConfig.loadConfig();
    final Box _box = await Hive.openBox(appConfig.articlesBox);
    final result = await repository.getArticles(url);
    if (_box.isOpen) {
      await _box.compact();
      await _box.close();
    }
    return result;
  }
}
