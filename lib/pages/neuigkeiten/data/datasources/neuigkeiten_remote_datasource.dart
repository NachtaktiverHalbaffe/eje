import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:dart_rss/dart_rss.dart';

class NeuigkeitenRemoteDatasource {
  final client = http.Client();
  var apiUrl = Uri.parse("https://www.eje-esslingen.de/meta/rss/");

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
            weiterfuehrender_link: items[i].link,
            published: parseDateTimeFromRSS(items[i].pubDate),
          ),
        );
      }
      return temp;
    } else {
      throw ServerException();
    }
  }

  DateTime parseDateTimeFromRSS(String dateFromSource) {
    //? Format from RSS-Feed: Mon, 15 Mar 21 09:00:00 +0100
    //Parse elements from unformatted DateTime
    int day = int.parse(dateFromSource.substring(5, 7));
    String monthString = dateFromSource.substring(0, 3);
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
    int year = int.parse("20" + dateFromSource.substring(12, 14));
    int hour = int.parse(dateFromSource.substring(15, 17));
    int minutes = int.parse(dateFromSource.substring(18, 20));
    int seconds = int.parse(dateFromSource.substring(21, 23));
    return DateTime(year, month, day, hour, minutes, seconds);
  }
}
