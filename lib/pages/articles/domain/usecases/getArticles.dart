import 'package:dartz/dartz.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/usecases/usecase.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/repositories/ArticlesRepository.dart';
import 'package:flutter/material.dart';

class GetArticles implements UseCase<List<Article>> {
  final ArticlesRepository repository;

  GetArticles(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call({
    @required String url,
  }) async {
    return await repository.getArticles(url);
  }
}
