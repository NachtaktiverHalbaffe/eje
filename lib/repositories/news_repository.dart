import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/datasources/LocalDataSource.dart';
import 'package:eje/datasources/WebScraper.dart';
import 'package:eje/datasources/news_remote_datasource.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/failures.dart';
import 'package:eje/models/news.dart';
import 'package:eje/utils/network_info.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';

class NewsRepository {
  final NewsRemoteDatasource remoteDataSource;
  final LocalDataSource<News, String> localDatasource;
  final NetworkInfo networkInfo;

  NewsRepository(
      {required this.remoteDataSource,
      required this.localDatasource,
      required this.networkInfo});

  Future<Either<Failure, Article>> getSingleNews(String titel) async {
    Article article;
    //open database
    AppConfig appConfig = await AppConfig.loadConfig();
    Box box = Hive.box(appConfig.articlesBox);
    try {
      String url = "";
      List<News> news = await localDatasource.getAllElements(appConfig.newsBox);
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
  Future<Either<Failure, List<News>>> getNews() async {
    final AppConfig appConfig = await AppConfig.loadConfig();

    final prefs = GetStorage();
    //open database
    if (await networkInfo.isConnected) {
      try {
        final remoteNews = await remoteDataSource.getNews();
        print("Got Neuigkeiten from Internet");
        //cache articles from article into local storage
        await localDatasource.cacheElements(appConfig.newsBox, remoteNews);
        //Storing length of items for notification background service
        List<String> newsNames = List.empty(growable: true);
        List<News> news =
            await localDatasource.getAllElements(appConfig.newsBox);
        for (var i = 0; i < news.length; i++) {
          newsNames.add(news[i].title);
        }
        prefs.write("cached_neuigkeiten", newsNames);
        return Right(await localDatasource.getAllElements(appConfig.newsBox));
      } on ServerException {
        print("News: Serverexception");
        return Left(ServerFailure());
      } on ConnectionException {
        print("News: Connectionexception");
        return Left(ConnectionFailure());
      }
    } else {
      return Right(await localDatasource.getAllElements(appConfig.newsBox));
    }
  }
}
