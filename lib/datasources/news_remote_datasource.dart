import 'package:eje/app_config.dart';
import 'package:eje/datasources/RemoteDataSource.dart';
import 'package:eje/models/exception.dart';
import 'package:eje/models/news.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:webfeed_revised/domain/rss_feed.dart';

class NewsRemoteDatasource implements RemoteDataSource<News, String> {
  final client = http.Client();

  @override
  Future<List<News>> getAllElements() async {
    // Load config constants
    final appConfig = await AppConfig.loadConfig();
    final apiUrl = Uri.parse(appConfig.domain + appConfig.newsEndpoint);
    // Init vars
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
}
