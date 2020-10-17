import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/articles/data/datasources/articlesLocalDatasource.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/articles/domain/repositories/ArticlesRepository.dart';
import 'package:eje/pages/articles/domain/usecases/getArticles.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
    List<Article> articles = List();
    //open database
    _box = await Hive.openBox('Articles');
    try {
      bool isInCache = false;
      List<Article> _article = await WebScraper().scrapeWebPage(url);
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
          List<Article> _webScrapingResult =
              await WebScraper().scrapeWebPage(url);
          _box.addAll(_webScrapingResult);
          articles.addAll(_webScrapingResult);
        }
        _box.compact();
        _box.close();
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
      _box.compact();
      _box.close();
      return Left(CacheFailure());
    }
  }

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Article>> getArticle(String url) async {
    Box _box = await Hive.box('Articles');
    List<Article> articles;
    if (await networkInfo.isConnected && url != "") {
      try {
        articles = await WebScraper().scrapeWebPage(url);
        List<Hyperlink> hyperlink = List();
        List<String> bilder = List();
        String content = "";
        String titel = "";
        bool foundTitle = false;
        for (int i = 0; i < articles.length; i++) {
          if (articles[i].bilder[0] != "") {
            bilder.addAll(articles[i].bilder);
          }
          if (articles[i].hyperlinks[0].link != "") {
            hyperlink.addAll(articles[i].hyperlinks);
          }
          if (articles[i].content != "" && articles[i].content.length != 2) {
            print("Content: " + articles[i].content);
            content = content + articles[i].content;
          }
          if (articles[i].titel != "") {
            if (!foundTitle) {
              foundTitle = true;
              titel = articles[i].titel;
            }
          }
        }
        if (hyperlink.isEmpty) {
          hyperlink.add(Hyperlink(link: "", description: ""));
        }
        if (bilder.isEmpty) {
          bilder.add("");
        }
        Article _article = Article(
          bilder: bilder,
          hyperlinks: hyperlink,
          titel: titel,
          content: content,
          url: url,
        );
        localDatasource.cacheArticle(_article);
        return Right(_article);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else
      try {
        Article _article = localDatasource.getArticle(url);
        return Right(_article);
      } on CacheException {
        return Left(CacheFailure());
      }
  }
}
