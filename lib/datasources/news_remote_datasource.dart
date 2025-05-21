import 'package:eje/app_config.dart';
import 'package:eje/datasources/remote_data_source.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/news.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:webfeed_revised/domain/rss_feed.dart';

class NewsRemoteDatasource implements RemoteDataSource<News, String> {
  final Client client;

  NewsRemoteDatasource({required this.client});

  @override
  Future<List<News>> getAllElements() async {
    // Load config constants
    final appConfig = await AppConfig.loadConfig();
    final apiUrl = Uri.parse(appConfig.domain + appConfig.newsEndpoint);

    List<News> data = List.empty(growable: true);
    Response response;
    try {
      response = await client.get(apiUrl);
    } catch (e) {
      print("NewsAPI error: $e");
      throw ConnectionException();
    }
    if (response.statusCode == 200) {
      var payload = RssFeed.parse(response.body).items!.toList();

      // Parsing
      if (payload.isNotEmpty) {
        for (int i = 0; i < payload.length; i++) {
          String content = payload[i].description!.trim();
          if (content.contains("<img src=")) {
            content = payload[i]
                .description!
                .substring(0, payload[i].description!.indexOf("<img src="));
          }
          data.add(
            News(
              title: payload[i].title ?? "",
              textPreview: content.trim(),
              text: content.trim(),
              images: payload[i].enclosure == null
                  ? [""]
                  : [payload[i].enclosure!.url ?? ""],
              link: payload[i].link ?? "",
              published: parseDateTimeFromRSS(payload[i].pubDate.toString()),
            ),
          );
        }
        _setPrefrenceCachedNews(data);
        return data;
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<News> getElement(String elementId) {
    throw UnimplementedError();
  }

  DateTime parseDateTimeFromRSS(String dateFromSource) {
    //? Format from RSS-Feed: 0022-08-17 14:59:00.000
    //Parse elements from unformatted DateTime
    int day = int.parse(dateFromSource.substring(8, 10));
    int month = int.parse(dateFromSource.substring(5, 7));
    int year = int.parse("20${dateFromSource.substring(2, 4)}");
    int hour = int.parse(dateFromSource.substring(11, 13));
    int minutes = int.parse(dateFromSource.substring(14, 16));
    int seconds = int.parse(dateFromSource.substring(17, 19));
    return DateTime(year, month, day, hour, minutes, seconds);
  }

  void _setPrefrenceCachedNews(List<News> news) {
    List<String> newsIds = List.empty(growable: true);
    for (int i = 0; i < news.length; i++) {
      newsIds.add(news[i].title);
    }
    GetStorage().write("cached_neuigkeiten", newsIds);
  }
}
