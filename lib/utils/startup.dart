import 'package:eje/models/Article.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/models/Event.dart';
import 'package:eje/models/Hyperlink.dart';
import 'package:eje/models/Offered_Service.dart';
import 'package:eje/models/camp.dart';
import 'package:eje/models/employee.dart';
import 'package:eje/models/field_of_work.dart';
import 'package:eje/models/location.dart';
import 'package:eje/models/news.dart';
import 'package:eje/utils/notificationplugin.dart';
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

    // await Permission.notification.request();
    // await Permission.ignoreBatteryOptimizations.request();
  }
  // Reset filters
  prefs.write("campFilterAge", -1);
  prefs.write("campFilterPrice", -1);
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
  Hive.registerAdapter(OfferedServiceAdapter());
  Hive.registerAdapter(HyperlinkAdapter());
  Hive.registerAdapter(LocationAdapter());
  await di.init();

  //Local notifications
  notificationPlugin.setListenerForLowerVersions(onNotificationInLowerVersion);
}

onNotificationInLowerVersion(ReceivedNotification receivedNotification) {}
