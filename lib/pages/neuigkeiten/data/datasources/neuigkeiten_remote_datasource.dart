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
            published: parseDateTimeFromRSS(items[i].pubDate),
          ),
        );
      }
      print(temp);
      return temp;
    } else {
      throw ServerException();
    }
  }

  DateTime parseDateTimeFromRSS(String dateFromSource) {
    //? Format from RSS-Feed: Tue, 08 Sep 20 17:00:54 +0200
    //Parse elements from unformatted DateTime
    String weekday = dateFromSource.substring(0, 2);
    int day = int.parse(dateFromSource.substring(5, 7));
    String monthname = dateFromSource.substring(8, 11);
    int month = 1;
    //Parse monthname to Integer
    if (monthname == "Jan") month = 1;
    if (monthname == "Feb") month = 2;
    if (monthname == "Mar") month = 3;
    if (monthname == "Apr") month = 4;
    if (monthname == "May") month = 5;
    if (monthname == "Jun") month = 6;
    if (monthname == "Jul") month = 7;
    if (monthname == "Aug") month = 8;
    if (monthname == "Sep") month = 9;
    if (monthname == "Oct") month = 10;
    if (monthname == "Nov") month = 11;
    if (monthname == "Dec") month = 12;
    int year = int.parse("20" + dateFromSource.substring(13, 15));
    int hour = int.parse(dateFromSource.substring(15, 17));
    int minutes = int.parse(dateFromSource.substring(18, 20));
    int seconds = int.parse(dateFromSource.substring(21, 23));
    return DateTime(year, month, day, hour, minutes, seconds);
  }
}
