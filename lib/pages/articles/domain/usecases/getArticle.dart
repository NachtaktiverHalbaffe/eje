import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/repositories/ArticlesRepository.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GetArticle implements UseCase<Article> {
  final ArticlesRepository repository;

  GetArticle(this.repository);

  @override
  Future<Either<Failure, Article>> call({
    @required String url,
  }) async {
    Box _box = await Hive.openBox('Articles');
    final result = await repository.getArticle(url);
    await _box.compact();
    //await _box.close();
    return result;
  }
}