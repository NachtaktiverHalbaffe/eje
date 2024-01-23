import 'package:cached_network_image/cached_network_image.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

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
    Widget fileImage = Container(
      height: height != 0.0 ? height : null,
      width: width != 0.0 ? width : null,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: url != "" && !url.contains("http")
              ? ExactAssetImage(url)
              : ExactAssetImage("assets/images/placeholder.jpeg"),
        ),
      ),
    );

    if (GetStorage().read('cache_pictures') && url.contains("http")) {
      return Container(
        height: height != 0.0 ? height : null,
        width: width != 0.0 ? width : null,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: url,
          imageBuilder: (context, imageProvider) => Container(
            height: height != 0.0 ? height : null,
            width: width != 0.0 ? width : null,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.center,
                image: CachedNetworkImageProvider(url),
              ),
            ),
          ),
          // progressIndicatorBuilder: (context, url, progress) =>
          //     LoadingIndicator(),
          placeholder: (context, url) => fileImage,
          errorWidget: (context, url, error) => fileImage,
        ),
      );
    } else if (url.contains("https")) {
      return Container(
        height: height != 0.0 ? height : null,
        width: width != 0.0 ? width : null,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FadeInImage(
              // image: NetworkImage(url),
              image: Image.network(
                url,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return LoadingIndicator();
                  } else {
                    return child;
                  }
                },
              ).image,
              placeholder: ExactAssetImage("assets/images/placeholder.jpeg"),
            ).image,
          ),
        ),
      );
    } else {
      return fileImage;
    }
  }
}
