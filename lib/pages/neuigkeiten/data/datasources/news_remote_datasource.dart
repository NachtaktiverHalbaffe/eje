import 'package:eje/app_config.dart';
import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/news.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:http/http.dart';

class NewsRemoteDatasource {
  final client = http.Client();

  Future<List<News>> getNews() async {
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
      var payload = RssFeed.parse(response.body).items.toList();

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
              published: parseDateTimeFromRSS(payload[i].pubDate ?? ""),
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

  DateTime parseDateTimeFromRSS(String dateFromSource) {
    //? Format from RSS-Feed: Mon, 15 Mar 21 09:00:00 +0100
    //Parse elements from unformatted DateTime
    int day = int.parse(dateFromSource.substring(5, 7));
    String monthString = dateFromSource.substring(8, 11);
    int month = 1;
    if (monthString.toLowerCase() == "jan") {
      month = 1;
    } else if (monthString.toLowerCase() == "feb") {
      month = 2;
    } else if (monthString.toLowerCase() == "mar") {
      month = 3;
    } else if (monthString.toLowerCase() == "apr") {
      month = 4;
    } else if (monthString.toLowerCase() == "may") {
      month = 5;
    } else if (monthString.toLowerCase() == "jun") {
      month = 6;
    } else if (monthString.toLowerCase() == "jul") {
      month = 7;
    } else if (monthString.toLowerCase() == "aug") {
      month = 8;
    } else if (monthString.toLowerCase() == "sep") {
      month = 9;
    } else if (monthString.toLowerCase() == "oct") {
      month = 10;
    } else if (monthString.toLowerCase() == "nov") {
      month = 11;
    } else if (monthString.toLowerCase() == "dec") {
      month = 12;
    }
    int year = int.parse("20${dateFromSource.substring(12, 14)}");
    int hour = int.parse(dateFromSource.substring(15, 17));
    int minutes = int.parse(dateFromSource.substring(18, 20));
    int seconds = int.parse(dateFromSource.substring(21, 23));
    return DateTime(year, month, day, hour, minutes, seconds);
  }
}
