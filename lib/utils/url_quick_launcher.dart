import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlQuickLauncher {
  Future<void> openTel(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: "tel", path: phoneNumber);

    await _lauchUri(launchUri);
  }

  Future<void> openMail(String mailAdress) async {
    final Uri launchUri = Uri(scheme: "mailto", path: mailAdress);

    await _lauchUri(launchUri);
  }

  Future<void> openHttps(String httpsLink) async {
    if (await canLaunchUrlString(httpsLink)) {
      await launchUrlString(httpsLink);
    } else {
      throw 'Could not open $httpsLink';
    }
  }

  Future<void> _lauchUri(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw "Could not open URI ${uri.toString()}";
    }
  }
}
