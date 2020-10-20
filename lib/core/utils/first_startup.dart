import 'package:eje/core/platform/Reminder.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/termine/domain/entities/Ort.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

import 'injection_container.dart' as di;

Future<void> prefStartup() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("First_Startup") == null) {
    print("First startup. Setting default Preferences");
    prefs.setBool("First_Startup", true);
    prefs.setBool("nightmode_auto", true);
    prefs.setBool("nightmode_on", false);
    prefs.setBool("nightmode_off", false);
    prefs.setBool("notifications_on", true);
    prefs.setBool("notifications_neuigkeiten", false);
    prefs.setBool("notifications_freizeiten", true);
    prefs.setBool("notifications_veranstaltungen", true);
    prefs.setBool("only_wifi", false);
    prefs.setBool("cache_pictures", true);
  }
  //Setting Hive up
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(NeuigkeitAdapter());
  Hive.registerAdapter(HauptamtlicherAdapter());
  Hive.registerAdapter(BAKlerAdapter());
  Hive.registerAdapter(ArbeitsbereichAdapter());
  Hive.registerAdapter(TerminAdapter());
  Hive.registerAdapter(FreizeitAdapter());
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(ReminderAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(HyperlinkAdapter());
  Hive.registerAdapter(OrtAdapter());
  await di.init();
  //Local notifications
}
