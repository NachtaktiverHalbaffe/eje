import 'package:eje/app_config.dart';
import 'package:eje/core/utils/BackgroundServicesManager.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
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
        activeColorPrimary: Theme.of(context).accentColor,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Theme.of(context).accentColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CostumIcons.eje),
        iconSize: 26.0,
        title: ("Das eje"),
        activeColorPrimary: Theme.of(context).accentColor,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Theme.of(context).accentColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.today),
        iconSize: 26.0,
        title: ("Termine"),
        activeColorPrimary: Theme.of(context).accentColor,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Theme.of(context).accentColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.terrain),
        iconSize: 26.0,
        title: ("Freizeiten"),
        activeColorPrimary: Theme.of(context).accentColor,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Theme.of(context).accentColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        iconSize: 26.0,
        title: ("Einstellungen"),
        activeColorPrimary: Theme.of(context).accentColor,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Theme.of(context).accentColor,
      ),
    ];
  }

  // List of Widgetscreens for navigation bart
  List<Widget> _buildScreens() {
    return [Neuigkeiten(), eje(), Termine(), Freizeiten(), Einstellungen()];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: initialIndex),
      items: _navBarsItems(),
      screens: _buildScreens(),
      handleAndroidBackButtonPress: true,
      stateManagement: true,
      backgroundColor: Theme.of(context).backgroundColor,
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

Widget _MaterialApp(BuildContext context, int initialIndex) {
  return FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    initialData: null,
    builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
      return snapshot.hasData
          ? MaterialApp(
              title: 'EJW Esslingen',
              home: MyHomePage(
                title: 'EJW Esslingen',
                initialIndex: initialIndex,
              ),
              theme: ThemeData.light().copyWith(
                  // Firmenfarbe
                  accentColor: Color(0xFFCD2E32),
                  //Textcolors
                  primaryTextTheme:
                      Typography.material2018(platform: TargetPlatform.android)
                          .black,
                  textTheme:
                      Typography.material2018(platform: TargetPlatform.android)
                          .black,
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
              themeMode: snapshot.data.getBool("nightmode_auto")
                  ? ThemeMode.system
                  : snapshot.data.getBool("nightmode_on")
                      ? ThemeMode.dark
                      : ThemeMode.light,
            )
          : LoadingIndicator();
    },
  );
}
