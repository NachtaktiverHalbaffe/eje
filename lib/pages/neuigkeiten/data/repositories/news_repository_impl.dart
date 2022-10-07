import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
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
    @required this.remoteDataSource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Article>> getSingleNews(String titel) async {
    Article article;
    //open database
    AppConfig appConfig = await AppConfig.loadConfig();
    Box _box = Hive.box(appConfig.articlesBox);
    try {
      String url = "";
      List<News> _news = await localDatasource.getCachedNews();
      for (var value in _news) {
        if (value.title == titel) {
          //sing url of article if article isnt in cache
          url = value.link;
          for (int k = 0; k < _box.length; k++) {
            final Article _article = _box.getAt(k);
            if (_article.url == value.link) {
              Article _webScrapingResult =
                  await WebScraper().scrapeWebPage(url);
              article = _webScrapingResult;
              _box.deleteAt(k);
              _box.add(_webScrapingResult);
              return Right(article);
            }
          }
        }
      }
      // Only runs if article isn't in cache
      Article _webScrapingResult = await WebScraper().scrapeWebPage(url);
      _box.add(_webScrapingResult);
      article = _webScrapingResult;
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
        List<News> _news = await localDatasource.getCachedNews();
        for (var i = 0; i < _news.length; i++) {
          newsNames.add(_news[i].title);
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
