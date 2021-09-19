import 'package:cached_network_image/cached_network_image.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ImageProvider> prefImage(String url) async {
  // Load prefrence if image caching is enabled
  if (url == "" || url == null) {
    // TODO implement placeholder image
    return ExactAssetImage("assets/images/eje_transparent_header.gif");
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("cache_pictures")) {
    return url.contains("http")
        ? CachedNetworkImageProvider(url)
        : ExactAssetImage(url);
  } else
    return url.contains("http") ? NetworkImage(url) : ExactAssetImage(url);
}

class CachedImage extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  const CachedImage({Key key, this.url, this.height = 0.0, this.width = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (height != 0.0 && width == 0.0) {
      return FutureBuilder<ImageProvider>(
        future: prefImage(url),
        builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
          return snapshot.hasData
              ? Container(
                  height: height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: snapshot.data,
                    ),
                  ),
                )
              : Container(height: height);
        },
      );
    } else if (width != 0.0 && height == 0.0) {
      return FutureBuilder<ImageProvider>(
        future: prefImage(url),
        builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
          return snapshot.hasData
              ? Container(
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: snapshot.data,
                    ),
                  ),
                )
              : Container(width: width);
        },
      );
    } else if (width != 0.0 && height != 0.0) {
      return FutureBuilder<ImageProvider>(
        future: prefImage(url),
        builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
          return snapshot.hasData
              ? Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: snapshot.data,
                    ),
                  ),
                )
              : Container(
                  width: width,
                  height: height,
                );
        },
      );
    } else {
      return FutureBuilder<ImageProvider>(
        future: prefImage(url),
        builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
          return snapshot.hasData
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: snapshot.data,
                    ),
                  ),
                )
              : LoadingIndicator();
        },
      );
    }
  }
}
