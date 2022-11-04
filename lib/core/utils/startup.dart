import 'package:eje/core/platform/location.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/field_of_work.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/employee.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/news.dart';
import 'package:eje/pages/termine/domain/entities/Event.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'injection_container.dart' as di;

Future<void> startup() async {
  await GetStorage.init();
  final prefs = GetStorage();
  if (prefs.read("First_Startup") == null) {
    print("First startup. Setting default Preferences");
    prefs.write('First_Startup', true);
    prefs.write('nightmode_auto', true);
    prefs.write('nightmode_on', false);
    prefs.write('nightmode_off', false);
    prefs.write('notifications_on', true);
    prefs.write('notifications_neuigkeiten', true);
    prefs.write("notifications_veranstaltungen", true);
    prefs.write('notifications_freizeiten', true);
    prefs.write('notifications_scheduled', 0);
    prefs.write('only_wifi', false);
    prefs.write('cache_pictures', true);
    prefs.write('cached_neuigkeiten', [""]);
    prefs.write('cached_freizeiten', [0]);
    prefs.write('schedule_offset', 2);
  }
  // Reset filters
  prefs.write("campFilterAge", 0);
  prefs.write("campFilterPrice", 0);
  prefs.write("campFilterStartDate", "");
  prefs.write("campFilterEndDate", "");
  //Setting Hive up
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(NewsAdapter());
  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(BAKlerAdapter());
  Hive.registerAdapter(FieldOfWorkAdapter());
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(CampAdapter());
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(HyperlinkAdapter());
  Hive.registerAdapter(LocationAdapter());
  await di.init();

  //Local notifications
  notificationPlugin.setListenerForLowerVersions(onNotificationInLowerVersion);
}

onNotificationInLowerVersion(ReceivedNotification receivedNotification) {}
