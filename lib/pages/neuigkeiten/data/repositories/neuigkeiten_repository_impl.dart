import 'package:dartz/dartz.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/core/utils/WebScraper.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/ErrorArticle.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/errorNeuigkeit.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:eje/core/error/failures.dart';
import 'package:eje/core/platform/network_info.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_local_datasource.dart';
import 'package:eje/pages/neuigkeiten/data/datasources/neuigkeiten_remote_datasource.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/domain/repositories/neuigkeiten_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<Either<Failure, List<Article>>> getNeuigkeit(String titel) async {
    List<Article> article = new List.empty(growable: true);
    //open database
    Box _box = Hive.box('Articles');
    try {
      bool isInCache = false;
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
              article.add(_box.getAt(k));
              isInCache = true;
            }
          }
        }
      }
      if (isInCache == false) {
        List<Article> _webScrapingResult =
            await WebScraper().scrapeWebPage(url);
        _box.addAll(_webScrapingResult);
        print(_webScrapingResult[0].content);
        article.addAll(_webScrapingResult);
      }
      return Right(article);
    } on CacheException {
      return Right([getErrorArticle()]);
    }
  }

  //Lade Artikel aus den Internet herunter
  @override
  Future<Either<Failure, List<Neuigkeit>>> getNeuigkeiten() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //open database
    if (await networkInfo.isConnected) {
      try {
        final remoteNeuigkeiten = await remoteDataSource.getNeuigkeiten();
        print("Got Neuigkeiten from Internet");
        //cache articles from article into local storage
        localDatasource.cacheNeuigkeiten(remoteNeuigkeiten);
        //Storing length of items for notification background service
        List<String> _neuigkeiten_namen = List();
        List<Neuigkeit> _neuigkeiten =
            await localDatasource.getCachedNeuigkeiten();
        _neuigkeiten.forEach((element) {
          _neuigkeiten_namen.add(element.titel);
        });
        prefs.setStringList("cached_neuigkeiten", _neuigkeiten_namen);
        return Right(await localDatasource.getCachedNeuigkeiten());
      } on ServerException {
        print("Neuigkeiten: Serverexception");
        return Right([getErrorNeuigkeit()]);
      }
    } else
      return Right(await localDatasource.getCachedNeuigkeiten());
  }
}
