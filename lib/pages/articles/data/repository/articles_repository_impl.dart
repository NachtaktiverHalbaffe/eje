import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/articles/data/datasources/articles_local_datasource.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/repositories/articles_repository.dart';
import 'package:hive/hive.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  ArticlesRepositoryImpl({
    required this.localDatasource,
    required this.networkInfo,
  });

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<Article>>> getArticles(String url) async {
    AppConfig appConfig = await AppConfig.loadConfig();
    final Box box = Hive.box(appConfig.articlesBox);
    List<Article> articles = List.empty(growable: true);

    try {
      bool isInCache = false;
      List<Article> article = [await WebScraper().scrapeWebPage(url)];
      if (article[0].url != "") {
        for (var value in article) {
          if (value.url == url) {
            //sing url of ticle if ticle isnt in cache
            url = value.url;
            for (int k = 0; k < box.length; k++) {
              final Article article = box.getAt(k);
              if (article.url == value.url) {
                articles.add(box.getAt(k));
                isInCache = true;
              }
            }
          }
        }
        if (isInCache == false) {
          List<Article> webScrapingResult = [
            await WebScraper().scrapeWebPage(url)
          ];
          box.addAll(webScrapingResult);
          articles.addAll(webScrapingResult);
        }
        return Right(articles);
      } else {
        for (var value in article) {
          if (value.url == url) {
            //sing url of ticle if ticle isnt in cache
            url = value.url;
            for (int k = 0; k < box.length; k++) {
              final Article article = box.getAt(k);
              if (article.url == value.url) {
                articles.add(article);
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
    Article article;

    if (await networkInfo.isConnected) {
      if (url != "") {
        try {
          article = await WebScraper().scrapeWebPage(url);
          Article article0 = Article(
            bilder: article.bilder,
            hyperlinks: article.hyperlinks,
            titel: article.titel,
            content: article.content,
            url: url,
          );
          localDatasource.cacheArticle(article0);
          return Right(article0);
        } on ServerException {
          return Left(ServerFailure());
        } on ConnectionException {
          return Left(ConnectionFailure());
        }
      } else {
        return Left(ServerFailure());
      }
    } else {
      try {
        Article article0 = await localDatasource.getArticle(url);
        return Right(article0);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
