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
    List<Article> article = List();
    //open database
    Box _box = await Hive.box('Articles');
    try {
      bool isInCache = false;
      String url = "";
      List<Neuigkeit> _neuigkeiten = localDatasource.getCachedNeuigkeiten();
      for (var value in _neuigkeiten) {
        if (value.titel == titel) {
          //sing url of ticle if ticle isnt in cache
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
    //open database
    if (await networkInfo.isConnected) {
      try {
        final remoteNeuigkeiten = await remoteDataSource.getNeuigkeiten();
        print("Got Neuigkeiten from Internet");
        localDatasource.cacheNeuigkeiten(remoteNeuigkeiten);
        return Right(localDatasource.getCachedNeuigkeiten());
      } on ServerException {
        print("Neuigkeiten: Serverexception");
        return Right([getErrorNeuigkeit()]);
      }
    } else
      return Right(localDatasource.getCachedNeuigkeiten());
  }
}
