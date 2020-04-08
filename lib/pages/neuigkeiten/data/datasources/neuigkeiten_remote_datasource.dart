import 'package:eje/core/error/exception.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
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
            published: DateTime.parse(items[i].pubDate),
          ),
        );
      }
      print(temp);
      return temp;
    } else {
      throw ServerException();
    }
  }
}
