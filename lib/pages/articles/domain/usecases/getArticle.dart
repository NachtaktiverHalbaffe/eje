import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/repositories/ArticlesRepository.dart';
import 'package:flutter/material.dart';

class GetArticle implements UseCase<Article> {
  final ArticlesRepository repository;

  GetArticle(this.repository);

  @override
  Future<Either<Failure, Article>> call({
    @required String url,
  }) async {
    return await repository.getArticle(url);
  }
}
