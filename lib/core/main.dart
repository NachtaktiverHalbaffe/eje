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
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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
  runApp(MyApp(initialIndex));
  // Connect background
  await BackgroundServicesManager().connectBackgroundServices();
}

class MyApp extends StatelessWidget {
  final int initialIndex;

  MyApp(this.initialIndex); // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      // ignore: missing_return
      child: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
        if (state is InitialMainState) {
          return _MaterialApp(context, initialIndex);
        } else if (state is ChangedThemeToLight) {
          return _MaterialApp(context, initialIndex);
        } else if (state is ChangedThemeToDark) {
          return _MaterialApp(context, initialIndex);
        } else if (state is ChangedThemeToAuto) {
          return _MaterialApp(context, initialIndex);
        }
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.initialIndex}) : super(key: key);
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
        title: ("Termine"),
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
    return [Neuigkeiten(), Eje(), Termine(), Freizeiten(), Einstellungen()];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      resizeToAvoidBottomInset: true,
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
    );
  }

  @override
  void dispose() {
    // Alle Offline Datenbanken schließen
    Hive.close();
    super.dispose();
  }
}

// ignore: non_constant_identifier_names
Widget _MaterialApp(BuildContext context, int initialIndex) {
  final ThemeData themeLight = ThemeData.light();
  final ThemeData themeDark = ThemeData.dark();
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
        secondary: Color(0xFFCD2E32),
        background: Colors.white,
      ),
      // Text colors
      textSelectionTheme: themeLight.textSelectionTheme.copyWith(
        selectionColor: Theme.of(context).colorScheme.secondary,
      ),
      primaryTextTheme:
          Typography.material2018(platform: TargetPlatform.android).black,
      textTheme:
          Typography.material2018(platform: TargetPlatform.android).black,
      //Iconcolors und Widgetcolors
      primaryIconTheme: IconThemeData(color: Colors.black),
      dividerColor: Colors.black,
    ),
    darkTheme: themeDark.copyWith(
      colorScheme: themeDark.colorScheme.copyWith(
        // Firmenfarbe
        secondary: Color(0xFFCD2E32),
        background: Colors.black,
      ),
      // Text colors
      textSelectionTheme: themeLight.textSelectionTheme.copyWith(
        selectionColor: Theme.of(context).colorScheme.secondary,
      ),
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
