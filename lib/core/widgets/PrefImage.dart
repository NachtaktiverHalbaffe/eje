import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

ImageProvider PrefImage (String url, bool isCacheEnabled){
  if(isCacheEnabled){
    return CachedNetworkImageProvider(url);
  }else return NetworkImage(url);
}