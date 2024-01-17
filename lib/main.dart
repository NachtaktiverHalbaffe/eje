import 'package:eje/utils/background_services_manager.dart';
import 'package:eje/utils/injection_container.dart';
import 'package:eje/utils/notificationplugin.dart';
import 'package:eje/utils/startup.dart';
import 'package:eje/widgets/color_sheme.dart';
import 'package:eje/widgets/pages/main/bloc/main_bloc.dart';
import 'package:eje/widgets/pages/main/bloc/main_state.dart';
import 'package:eje/widgets/persistent_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await startup();
  //Getting data if app was launched from application
  int? initialIndex = 0;
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await notificationPlugin.flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails!.didNotificationLaunchApp) {
    initialIndex = int.parse(
        notificationAppLaunchDetails.notificationResponse?.payload ?? "0");
  }
  BackgroundServicesManager(
          newsRemoteDatasource: diContainer(),
          campsRemoteDatasource: diContainer())
      .initialize();
  FlutterBackgroundService().invoke("setAsForeGround");
  FlutterBackgroundService().invoke("setAsBackgorund");
  runApp(MyApp(initialIndex));
}

class MyApp extends StatelessWidget {
  final int initialIndex;

  MyApp(this.initialIndex); // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return BlocProvider(
      create: (context) => MainBloc(),
      child: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
        if (state is InitialMainState ||
            state is ChangedThemeToLight ||
            state is ChangedThemeToDark ||
            state is ChangedThemeToAuto) {
          return _MaterialApp(context, initialIndex);
        } else {
          return _MaterialApp(context, initialIndex);
        }
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required this.initialIndex})
      : super(key: key);
  final String title;
  final int initialIndex;

  @override
  State createState() => _MyHomePageState(initialIndex);
}

class _MyHomePageState extends State<MyHomePage> {
  final int initialIndex;

  _MyHomePageState(this.initialIndex); // List of Icons for Navigation bar

  late PermissionStatus status;
  void _firstStartDialog(BuildContext context) async {
    // Can throw initializationerror
    try {
      status = await Permission.ignoreBatteryOptimizations.status;
    } finally {
      if (status != PermissionStatus.permanentlyDenied &&
          status != PermissionStatus.granted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Berechtigungen gewähren'),
                content: Text(
                  "Die App benötigt Berechtigungen, damit alle Features einwandfrei ausgeführt werden können. Diese können jederzeit in den Systemeinstellungen und in den Appeinstellungen angepasst und wiederrufen werden.",
                  textAlign: TextAlign.justify,
                ),
                actions: [
                  MaterialButton(
                    onPressed: () async {
                      await Permission.notification.request();
                      await Permission.ignoreBatteryOptimizations.request();
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"),
                  ),
                ]);
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _firstStartDialog(context);
    return EjePersistentNavBar(initialIndex: initialIndex);
  }

  @override
  void dispose() {
    // Alle Offline Datenbanken schließen
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}

// ignore: non_constant_identifier_names
Widget _MaterialApp(BuildContext context, int initialIndex) {
  final prefs = GetStorage();
  return MaterialApp(
    title: 'EJW Esslingen',
    home: MyHomePage(
      title: 'EJW Esslingen',
      initialIndex: initialIndex,
    ),
    theme: getAppLightTheme(),
    darkTheme: getAppDarkTheme(),
    themeMode: prefs.read("nightmode_auto")
        ? ThemeMode.system
        : prefs.read("nightmode_on")
            ? ThemeMode.dark
            : ThemeMode.light,
  );
}
