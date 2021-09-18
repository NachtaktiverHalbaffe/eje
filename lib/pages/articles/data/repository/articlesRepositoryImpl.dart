import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/articles/data/datasources/articlesLocalDatasource.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/ErrorArticle.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/articles/domain/repositories/ArticlesRepository.dart';
import 'package:eje/pages/articles/domain/usecases/getArticles.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../app_config.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  ArticlesRepositoryImpl({
    @required this.localDatasource,
    @required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  Future<Either<Failure, List<Article>>> getArticles(String url) async {
    Box _box;
    List<Article> articles = new List.empty(growable: true);

    try {
      bool isInCache = false;
      List<Article> _article = [await WebScraper().scrapeWebPage(url)];
      if (_article[0].url != "") {
        for (var value in _article) {
          if (value.url == url) {
            //sing url of ticle if ticle isnt in cache
            url = value.url;
            for (int k = 0; k < _box.length; k++) {
              final Article _article = _box.getAt(k);
              if (_article.url == value.url) {
                articles.add(_box.getAt(k));
                isInCache = true;
              }
            }
          }
        }
        if (isInCache == false) {
          List<Article> _webScrapingResult = [
            await WebScraper().scrapeWebPage(url)
          ];
          _box.addAll(_webScrapingResult);
          articles.addAll(_webScrapingResult);
        }
        return Right(articles);
      } else {
        for (var value in _article) {
          if (value.url == url) {
            //sing url of ticle if ticle isnt in cache
            url = value.url;
            for (int k = 0; k < _box.length; k++) {
              final Article _article = _box.getAt(k);
              if (_article.url == value.url) {
                articles.add(_article);
              }
            }
          }
        }
        return Right(articles);
      }
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Article>> getArticle(String url) async {
    final appConfig = await AppConfig.loadConfig();
    final Box _box = Hive.box(appConfig.articlesBox);
    Article article;
    if (await networkInfo.isConnected) {
      if (url != "") {
        try {
          article = await WebScraper().scrapeWebPage(url);
          Article _article = Article(
            bilder: article.bilder,
            hyperlinks: article.hyperlinks,
            titel: article.titel,
            content: article.content,
            url: url,
          );

          localDatasource.cacheArticle(_article);
          return Right(_article);
        } on ServerException {
          return Right(getErrorArticle());
        }
      }
    } else
      try {
        Article _article = await localDatasource.getArticle(url);
        return Right(_article);
      } on CacheException {
        return Right(getErrorArticle());
      }
  }
}
