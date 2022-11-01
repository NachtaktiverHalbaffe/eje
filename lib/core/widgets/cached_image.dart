import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

ImageProvider prefImage(String url) {
  // Load prefrence if image caching is enabled
  if (url == "") {
    // TODO implement placeholder image
    return ExactAssetImage("assets/images/eje_transparent_header.gif");
  }

  if (GetStorage().read('cache_pictures')) {
    if (url.contains("http")) {
      return CachedNetworkImageProvider(url);
    } else {
      return ExactAssetImage(url);
    }
  } else {
    if (url.contains("http")) {
      return NetworkImage(url);
    } else {
      return ExactAssetImage(url);
    }
  }
}

class CachedImage extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  static const Key defaultkey = Key("");
  const CachedImage(
      {Key key = defaultkey,
      required this.url,
      this.height = 0.0,
      this.width = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (height != 0.0 && width == 0.0) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: prefImage(url),
          ),
        ),
      );
    } else if (height == 0.0 && width != 0.0) {
      return Container(
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: prefImage(url),
          ),
        ),
      );
    } else if (height != 0.0 && width != 0.0) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: prefImage(url),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: prefImage(url),
          ),
        ),
      );
    }
  }
}
