import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

ImageProvider prefImage(String url) {
  // Load prefrence if image caching is enabled
  if (url == "" || url == null) {
    // TODO implement placeholder image
    return ExactAssetImage("assets/images/eje_transparent_header.gif");
  }

  if (GetStorage().read('cache_pictures')) {
    return url.contains("http")
        ? CachedNetworkImageProvider(url)
        : ExactAssetImage(url);
  } else {
    return url.contains("http") ? NetworkImage(url) : ExactAssetImage(url);
  }
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
