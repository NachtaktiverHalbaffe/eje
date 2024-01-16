import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/datasources/LocalDataSource.dart';
import 'package:eje/datasources/WebScraper.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/utils/network_info.dart';
import 'package:hive/hive.dart';

class ArticlesRepository {
  final LocalDataSource<Article, String> localDatasource;
  final NetworkInfo networkInfo;

  ArticlesRepository(
      {required this.localDatasource, required this.networkInfo});

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

  Future<Either<Failure, Article>> getArticle(String url) async {
    Article article;
    final AppConfig appConfig = await AppConfig.loadConfig();

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
          localDatasource.cacheElement(appConfig.articlesBox, article0);
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
        Article article0 =
            await localDatasource.getElement(appConfig.articlesBox, url, "url");
        return Right(article0);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
