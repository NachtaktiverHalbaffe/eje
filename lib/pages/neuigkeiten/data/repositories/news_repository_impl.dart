import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/news_local_datasource.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/news_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/news.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDatasource remoteDataSource;
  final NewsLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDatasource,
    required this.networkInfo,
  });

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Article>> getSingleNews(String titel) async {
    Article article;
    //open database
    AppConfig appConfig = await AppConfig.loadConfig();
    Box box = Hive.box(appConfig.articlesBox);
    try {
      String url = "";
      List<News> news = await localDatasource.getCachedNews();
      for (var value in news) {
        if (value.title == titel) {
          //sing url of article if article isnt in cache
          url = value.link;
          for (int k = 0; k < box.length; k++) {
            // ignore: no_leading_underscores_for_local_identifiers
            final Article _article = box.getAt(k);
            if (_article.url == value.link) {
              Article webScrapingResult0 =
                  await WebScraper().scrapeWebPage(url);
              article = webScrapingResult0;
              box.deleteAt(k);
              box.add(webScrapingResult0);
              return Right(article);
            }
          }
        }
      }
      // Only runs if article isn't in cache
      Article webScrapingResult = await WebScraper().scrapeWebPage(url);
      box.add(webScrapingResult);
      article = webScrapingResult;
      return Right(article);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<News>>> getNews() async {
    final prefs = GetStorage();
    //open database
    if (await networkInfo.isConnected) {
      try {
        final remoteNews = await remoteDataSource.getNews();
        print("Got Neuigkeiten from Internet");
        //cache articles from article into local storage
        await localDatasource.cacheNews(remoteNews);
        //Storing length of items for notification background service
        List<String> newsNames = List.empty(growable: true);
        List<News> news = await localDatasource.getCachedNews();
        for (var i = 0; i < news.length; i++) {
          newsNames.add(news[i].title);
        }
        prefs.write("cached_neuigkeiten", newsNames);
        return Right(await localDatasource.getCachedNews());
      } on ServerException {
        print("News: Serverexception");
        return Left(ServerFailure());
      } on ConnectionException {
        print("News: Connectionexception");
        return Left(ConnectionFailure());
      }
    } else {
      return Right(await localDatasource.getCachedNews());
    }
  }
}
