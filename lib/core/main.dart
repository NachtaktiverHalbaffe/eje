import 'package:eje/core/utils/BackgroundServicesManager.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/core/widgets/bloc/main_bloc.dart';
import 'package:eje/core/widgets/bloc/main_state.dart';
import 'package:eje/core/widgets/costum_icons_icons.dart';
import 'package:eje/pages/einstellungen/einstellungen.dart';
import 'package:eje/pages/eje/eje.dart';
import 'package:eje/pages/freizeiten/freizeiten.dart';
import 'package:eje/pages/termine/termine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/neuigkeiten/neuigkeiten.dart';
import 'utils/startup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await startup();
  //Getting data if app was launched from application
  int initialIndex = 0;
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await notificationPlugin.flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails.didNotificationLaunchApp) {
    initialIndex = int.parse(notificationAppLaunchDetails.payload);
  }
  runApp(MyApp(await SharedPreferences.getInstance(), initialIndex));
  await BackgroundServicesManager().connectBackgroundServices();
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final int initialIndex;

  MyApp(this.prefs,
      this.initialIndex); // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      // ignore: missing_return
      child: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
        if (state is InitialMainState) {
          return _MaterialApp(context, prefs, initialIndex);
        } else if (state is ChangedThemeToLight) {
          return _MaterialApp(context, prefs, initialIndex);
        } else if (state is ChangedThemeToDark) {
          return _MaterialApp(context, prefs, initialIndex);
        } else if (state is ChangedThemeToAuto) {
          return _MaterialApp(context, prefs, initialIndex);
        }
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(
      {Key key, this.title, this.isCacheEnabled, this.prefs, this.initialIndex})
      : super(key: key);
  final String title;
  final bool isCacheEnabled;
  final SharedPreferences prefs;
  final int initialIndex;

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(isCacheEnabled, prefs, initialIndex);
}

class _MyHomePageState extends State<MyHomePage> {
  final bool isCacheEnabled;
  final SharedPreferences prefs;
  final int initialIndex;

  _MyHomePageState(this.isCacheEnabled, this.prefs,
      this.initialIndex); // List of Icons for Navigation bar
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.newspaper),
        title: ("Aktuelles"),
        activeColor: Theme.of(context).accentColor,
        activeContentColor: Colors.white,
        inactiveColor: Theme.of(context).accentColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CostumIcons.eje),
        title: ("Das eje"),
        activeColor: Theme.of(context).accentColor,
        activeContentColor: Colors.white,
        inactiveColor: Theme.of(context).accentColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.today),
        title: ("Termine"),
        activeColor: Theme.of(context).accentColor,
        activeContentColor: Colors.white,
        inactiveColor: Theme.of(context).accentColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.terrain),
        title: ("Freizeiten"),
        activeColor: Theme.of(context).accentColor,
        activeContentColor: Colors.white,
        inactiveColor: Theme.of(context).accentColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Einstellungen"),
        activeColor: Theme.of(context).accentColor,
        activeContentColor: Colors.white,
        inactiveColor: Theme.of(context).accentColor,
      ),
    ];
  }

  // List of Widgetscreens for navigation bart
  List<Widget> _buildScreens() {
    return [
      Neuigkeiten(isCacheEnabled),
      eje(isCacheEnabled),
      Termine(isCacheEnabled, prefs),
      Freizeiten(isCacheEnabled),
      Einstellungen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: PersistentTabController(initialIndex: initialIndex),
      items: _navBarsItems(),
      screens: _buildScreens(),
      handleAndroidBackButtonPress: true,
      stateManagement: true,
      backgroundColor: Theme.of(context).backgroundColor,
      iconSize: 26.0,
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
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Theme.of(context).backgroundColor,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      // Choose the nav bar style with this property
      onItemSelected: (index) {
        print(index);
      },
    );
  }

  @override
  void dispose() {
    // Alle Offline Datenbanken schließen
    Hive.close();
    super.dispose();
  }
}

Widget _MaterialApp(
    BuildContext context, SharedPreferences prefs, int initialIndex) {
  return MaterialApp(
    title: 'EJW Esslingen',
    home: MyHomePage(
      title: 'EJW Esslingen',
      isCacheEnabled: prefs.getBool("cache_pictures"),
      prefs: prefs,
      initialIndex: initialIndex,
    ),
    theme: ThemeData.light().copyWith(
// Firmenfarbe
        accentColor: Color(0xFFCD2E32),
//Textcolors
        primaryTextTheme:
            Typography.material2018(platform: TargetPlatform.android).black,
        textTheme:
            Typography.material2018(platform: TargetPlatform.android).black,
        textSelectionColor: Theme.of(context).accentColor,
//Iconcolors und Widgetcolors
        primaryIconTheme: IconThemeData(color: Colors.black),
        dividerColor: Colors.black,
        backgroundColor: Colors.white,
        cardColor: Colors.white),
    darkTheme: ThemeData.dark().copyWith(
//Firmenfarbe
      accentColor: Color(0xFFCD2E32),
//Textcolors
      textSelectionColor: Theme.of(context).accentColor,
//Iconcolors und Widgetcolors
      dividerColor: Colors.white,
      backgroundColor: Colors.black,
    ),
    themeMode: prefs.getBool("nightmode_auto")
        ? ThemeMode.system
        : prefs.getBool("nightmode_on")
            ? ThemeMode.dark
            : ThemeMode.light,
  );
}
