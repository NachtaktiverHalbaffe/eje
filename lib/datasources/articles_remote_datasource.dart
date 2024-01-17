import 'package:eje/datasources/RemoteDataSource.dart';
import 'package:eje/datasources/WebScraper.dart';
import 'package:eje/models/Article.dart';
import 'package:eje/models/exception.dart';

class ArticlesRemoteDatasource implements RemoteDataSource<Article, String> {
  @override
  Future<List<Article>> getAllElements() async {
    throw UnimplementedError();
  }

  @override
  Future<Article> getElement(String elementId) async {
    try {
      return await WebScraper().scrapeWebPage(elementId);
    } on ServerException {
      throw ServerException();
    } on ConnectionException {
      throw ConnectionException();
    }
  }
}
