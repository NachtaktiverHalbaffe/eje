import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:webfeed/domain/rss_feed.dart';

class NeuigkeitenRemoteDatasource {
  final http.Client client;
  final String apiUrl = "https://www.eje-esslingen.de/meta/rss/";

  NeuigkeitenRemoteDatasource({@required this.client});

  Future<List<Neuigkeit>> getNeuigkeiten() async {
    List<Neuigkeit> temp = new List<Neuigkeit>();
    final response = await client.get(apiUrl);
    String bodyString = response.body;
    var channel = new RssFeed.parse(bodyString);
    var items = channel.items.toList();
    if (items.length != 0) {
      for (int i = 0; i < items.length; i++) {
        String content = items[i].description;
        if (content.contains("<img src=")) {
          content = items[i]
              .description
              .substring(0, items[i].description.indexOf("<img src="));
        }
        temp.add(
          new Neuigkeit(
            titel: items[i].title,
            text_preview: content,
            text: content,
            bilder: items[i].enclosure == null
                ? [
                    "http://www.sjr-es.de/media/zoo/images/eje_logo_9df3b8fbf18c2d3a99928fa9bfbe0da3.jpg"
                  ]
                : [items[i].enclosure.url],
            weiterfuehrender_link: items[i].guid,
            published: parseDateTimeFromRSS(items[i].pubDate.toString()),
          ),
        );
        print(items[i].pubDate);
        print(temp[i].published);
      }
      return temp;
    } else {
      throw ServerException();
    }
  }

  DateTime parseDateTimeFromRSS(String dateFromSource) {
    //? Format from RSS-Feed: 0020-02-20 12:35:03.000
    //Parse elements from unformatted DateTime
    int day = int.parse(dateFromSource.substring(8, 10));
    int month = int.parse(dateFromSource.substring(5, 7));
    int year = int.parse("20" + dateFromSource.substring(2, 4));
    int hour = int.parse(dateFromSource.substring(11, 13));
    int minutes = int.parse(dateFromSource.substring(14, 16));
    int seconds = int.parse(dateFromSource.substring(17, 19));
    return DateTime(year, month, day, hour, minutes, seconds);
  }
}
