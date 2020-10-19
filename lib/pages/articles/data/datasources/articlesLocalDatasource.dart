import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/ErrorArticle.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:hive/hive.dart';

class ArticlesLocalDatasource {
  List<Article> getCachedArticles() {
    Box _box;
    _box = Hive.box('Articles');
    if (_box.isNotEmpty) {
      List<Article> temp = new List<Article>();
      for (int i = 0; i < _box.length; i++) {
        if (_box.getAt(i) != null) {
          temp.add(_box.getAt(i));
        }
      }
      return temp;
    } else {
      throw CacheException();
    }
  }

  Article getArticle(String url) {
    Box _box = Hive.box('Articles');
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Article temp = _box.getAt(i);
        if (temp.url == url) {
          return temp;
        }
      }
      return getErrorArticle();
    } else {
      return getErrorArticle();
    }
  }

  void cacheArticle(Article article) async {
    Box _box = Hive.box('Articles');
    bool isAlreadyCached = false;
    if (_box.isNotEmpty) {
      for (int i = 0; i < _box.length; i++) {
        Article temp = _box.getAt(i);
        if (temp.url == article.url) {
          isAlreadyCached == true;
          _box.deleteAt(i);
          _box.add(article);
        }
      }
      if (!isAlreadyCached) {
        _box.add(article);
      }
    } else if (_box.isEmpty) {
      _box.add(article);
    } else {
      throw CacheException();
    }
  }

  void cacheArticles(List<Article> articlesToCache) {
    Box _box = Hive.box('Articles');
    for (int i = 0; i < articlesToCache.length; i++) {
      bool alreadyexists = false;
      for (int k = 0; k < _box.length; k++) {
        final Article _article = _box.getAt(k);
        if (_article.url == articlesToCache[i].url) {
          alreadyexists = true;
        }
      }
      if (alreadyexists == false) {
        _box.add(articlesToCache[i]);
      }
    }
  }
}
