import 'package:eje/core/utils/background_services_manager.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/core/widgets/bloc/main_bloc.dart';
import 'package:eje/core/widgets/bloc/main_state.dart';
import 'package:eje/core/widgets/costum_icons_icons.dart';
import 'package:eje/pages/einstellungen/einstellungen.dart';
import 'package:eje/pages/eje/eje.dart';
import 'package:eje/pages/freizeiten/camps.dart';
import 'package:eje/pages/termine/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:workmanager/workmanager.dart';
import 'pages/neuigkeiten/news_page.dart';
import 'core/utils/startup.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await BackgroundServicesManager.checkFreizeitenNotification();
    } catch (e) {
      print("CheckCampsTask failed. Reason: $e");
    }

    try {
      await BackgroundServicesManager.checkNeuigkeitenNotification();
    } catch (e) {
      print("CheckNeuigkeitenTask failed. Reason: $e");
    }

    print("Background Task has successfully run");
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  runApp(MyApp(initialIndex));
}

class MyApp extends StatelessWidget {
  final int initialIndex;

  MyApp(this.initialIndex); // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
  _MyHomePageState createState() => _MyHomePageState(initialIndex);
}

class _MyHomePageState extends State<MyHomePage> {
  final int initialIndex;

  _MyHomePageState(this.initialIndex); // List of Icons for Navigation bar
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.newspaper),
        iconSize: 26.0,
        title: ("Aktuelles"),
        activeColorPrimary: Theme.of(context).colorScheme.secondary,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CostumIcons.eje),
        iconSize: 26.0,
        title: ("Das eje"),
        activeColorPrimary: Theme.of(context).colorScheme.secondary,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.today),
        iconSize: 26.0,
        title: ("Events"),
        activeColorPrimary: Theme.of(context).colorScheme.secondary,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.terrain),
        iconSize: 26.0,
        title: ("Freizeiten"),
        activeColorPrimary: Theme.of(context).colorScheme.secondary,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        iconSize: 26.0,
        title: ("Einstellungen"),
        activeColorPrimary: Theme.of(context).colorScheme.secondary,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
      ),
    ];
  }

  // List of Widgetscreens for navigation bart
  List<Widget> _buildScreens() {
    return [NewsPage(), Eje(), Events(), Camps(), Einstellungen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        resizeToAvoidBottomInset: false,
        controller: PersistentTabController(initialIndex: initialIndex),
        items: _navBarsItems(),
        screens: _buildScreens(),
        handleAndroidBackButtonPress: true,
        stateManagement: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        navBarStyle: NavBarStyle
            .style7, //!Good looking alternatives: sytle3, style6, style7, style 15
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        decoration: NavBarDecoration(
          boxShadow: GetStorage().read("nightmode_off") == true ||
                  (GetStorage().read("nightmode_auto") == true &&
                      MediaQuery.of(context).platformBrightness ==
                          Brightness.light)
              ? [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ]
              : [],
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Theme.of(context).colorScheme.background,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        // Choose the nav bar style with this property
        onItemSelected: (index) {},
      ),
    );
  }

  @override
  void dispose() {
    // Alle Offline Datenbanken schließen
    Hive.close();
    super.dispose();
  }

  @override
  void initState() {
    // Register background task which will fetch new news and camp data from the apis and send notification if theres new content
    Workmanager().registerPeriodicTask("1", "NotificationChecker",
        constraints: Constraints(networkType: NetworkType.connected),
        frequency: Duration(hours: 1));
    super.initState();
  }
}

// ignore: non_constant_identifier_names
Widget _MaterialApp(BuildContext context, int initialIndex) {
  final ThemeData themeLight = ThemeData.light();
  final ThemeData themeDark = ThemeData.dark();
  // Theme propertys that stay the same in darkmode and lightmode
  final Color companyColor = Color(0xFFCD2E32);
  final OutlinedButtonThemeData outlinedButtonThemeData =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: companyColor,
    ),
  );
  final TextButtonThemeData textButtonThemeData = TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor:
          MaterialStateProperty.resolveWith((states) => companyColor),
    ),
  );

  final prefs = GetStorage();
  return MaterialApp(
    title: 'EJW Esslingen',
    home: MyHomePage(
      title: 'EJW Esslingen',
      initialIndex: initialIndex,
    ),
    theme: themeLight.copyWith(
      colorScheme: themeLight.colorScheme.copyWith(
        // Firmenfarbe
        secondary: companyColor,
        background: Colors.white,
        primary: companyColor,
      ),
      // Text colors
      textSelectionTheme: themeLight.textSelectionTheme.copyWith(
        selectionColor: companyColor,
        selectionHandleColor: companyColor,
        cursorColor: companyColor,
      ),
      primaryTextTheme:
          Typography.material2018(platform: TargetPlatform.android).black,
      textTheme:
          Typography.material2018(platform: TargetPlatform.android).black,
      // Only OutlinedButtons are used as buttons in this app
      outlinedButtonTheme: outlinedButtonThemeData,
      // Used in showAboutDialog
      textButtonTheme: textButtonThemeData,
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: themeLight.disabledColor, width: 2.0),
        fillColor: MaterialStateProperty.resolveWith((states) => companyColor),
      ),
      // Used in LoadingIndicator and another loading animations
      progressIndicatorTheme: ProgressIndicatorThemeData(color: companyColor),
      primaryIconTheme: IconThemeData(color: Colors.black),
      dividerColor: Colors.black,
    ),
    darkTheme: themeDark.copyWith(
      colorScheme: themeDark.colorScheme.copyWith(
        // Firmenfarbe
        secondary: companyColor,
        background: Colors.black,
        primary: companyColor,
      ),
      // Text colors
      textSelectionTheme: themeDark.textSelectionTheme.copyWith(
        selectionColor: companyColor,
        selectionHandleColor: companyColor,
        cursorColor: companyColor,
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(
          color: themeDark.disabledColor,
          width: 2.0,
        ),
        fillColor: MaterialStateProperty.resolveWith((states) => companyColor),
      ),
      // Only OutlinedButtons are used as buttons in this app
      outlinedButtonTheme: outlinedButtonThemeData,
      // Used in showAboutDialog
      textButtonTheme: textButtonThemeData,
      textTheme: TextTheme(
        overline: TextStyle(color: companyColor),
      ),
      // Used in LoadingIndicator and another loading animations
      progressIndicatorTheme: ProgressIndicatorThemeData(color: companyColor),
      //Iconcolors und Widgetcolors
      dividerColor: Colors.white,
    ),
    themeMode: prefs.read("nightmode_auto")
        ? ThemeMode.system
        : prefs.read("nightmode_on")
            ? ThemeMode.dark
            : ThemeMode.light,
  );
}
