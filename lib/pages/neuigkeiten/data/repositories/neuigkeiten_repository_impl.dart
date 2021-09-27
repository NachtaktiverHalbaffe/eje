import 'package:dartz/dartz.dart';
import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/ErrorArticle.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/errorNeuigkeit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_local_datasource.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/neuigkeiten_repository.dart';

class NeuigkeitenRepositoryImpl implements NeuigkeitenRepository {
  final NeuigkeitenRemoteDatasource remoteDataSource;
  final NeuigkeitenLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  //Constructor
  NeuigkeitenRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDatasource,
    @required this.networkInfo,
  });

  //Lade bestimmten Artikel aus Cache
  @override
  Future<Either<Failure, Article>> getNeuigkeit(String titel) async {
    Article article;
    //open database
    AppConfig appConfig = await AppConfig.loadConfig();
    Box _box = Hive.box(appConfig.articlesBox);
    try {
      String url = "";
      List<Neuigkeit> _neuigkeiten =
          await localDatasource.getCachedNeuigkeiten();
      for (var value in _neuigkeiten) {
        if (value.titel == titel) {
          //sing url of article if article isnt in cache
          url = value.weiterfuehrender_link;
          for (int k = 0; k < _box.length; k++) {
            final Article _article = _box.getAt(k);
            if (_article.url == value.weiterfuehrender_link) {
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
      return Right(getErrorArticle());
    }
  }

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<Neuigkeit>>> getNeuigkeiten() async {
    final prefs = GetStorage();
    //open database
    if (await networkInfo.isConnected) {
      try {
        final remoteNeuigkeiten = await remoteDataSource.getNeuigkeiten();
        print("Got Neuigkeiten from Internet");
        //cache articles from article into local storage
        await localDatasource.cacheNeuigkeiten(remoteNeuigkeiten);
        //Storing length of items for notification background service
        List<String> neuigkeitenNamen = List.empty(growable: true);
        List<Neuigkeit> _neuigkeiten =
            await localDatasource.getCachedNeuigkeiten();
        _neuigkeiten.forEach((element) {
          neuigkeitenNamen.add(element.titel);
        });
        prefs.write("cached_neuigkeiten", neuigkeitenNamen);
        return Right(await localDatasource.getCachedNeuigkeiten());
      } on ServerException {
        print("Neuigkeiten: Serverexception");
        return Right([getErrorNeuigkeit()]);
      }
    } else
      return Right(await localDatasource.getCachedNeuigkeiten());
  }
}
