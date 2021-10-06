import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncher {
  static String createURIString(String query) {
    Uri uri;

    if (kIsWeb) {
      uri = Uri.https(
          'www.google.com', '/maps/search/', {'api': '1', 'query': query});
    } else if (Platform.isAndroid) {
      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
    } else if (Platform.isIOS) {
      uri = Uri.https('maps.apple.com', '/', {'q': query});
    } else {
      uri = Uri.https(
          'www.google.com', '/maps/search', {'api': '1', 'query': query});
    }

    return uri.toString();
  }

  static Future<bool> launchQuery(String uri) async {
    if (await canLaunch(createURIString(uri))) {
      return launch(createURIString(uri));
    } else {
      return false;
    }
  }
}
