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
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/neuigkeiten/neuigkeiten.dart';
import 'utils/first_startup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await prefStartup();
  runApp(MyApp(await SharedPreferences.getInstance()));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  MyApp(this.prefs); // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(),
      // ignore: missing_return
      child: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
        if (state is InitialMainState) {
          return _MaterialApp(context, prefs);
        } else if (state is ChangedTheme) {
          return _MaterialApp(context, prefs);
        }
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.isCacheEnabled}) : super(key: key);
  final String title;
  final bool isCacheEnabled;

  @override
  _MyHomePageState createState() => _MyHomePageState(isCacheEnabled);
}

class _MyHomePageState extends State<MyHomePage> {
  final bool isCacheEnabled;

  _MyHomePageState(this.isCacheEnabled); // List of Icons for Navigation bar
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.newspaper),
        title: ("Aktuelles"),
        activeColor: Theme.of(context).accentColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CostumIcons.eje),
        title: ("Das eje"),
        activeColor: Theme.of(context).accentColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.today),
        title: ("Termine"),
        activeColor: Theme.of(context).accentColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MdiIcons.terrain),
        title: ("Freizeiten"),
        activeColor: Theme.of(context).accentColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Einstellungen"),
        activeColor: Theme.of(context).accentColor,
      ),
    ];
  }

  // List of Widgetscreens for navigation bart
  List<Widget> _buildScreens() {
    return [
      Neuigkeiten(isCacheEnabled),
      eje(isCacheEnabled),
      Termine(isCacheEnabled),
      Freizeiten(isCacheEnabled),
      Einstellungen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: PersistentTabController(initialIndex: 0),
      items: _navBarsItems(),
      screens: _buildScreens(),
      handleAndroidBackButtonPress: true,
      stateManagement: true,
      backgroundColor: Theme.of(context).backgroundColor,
      iconSize: 26.0,
      //navBarStyle: NavBarStyle.style6,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      // Choose the nav bar style with this property
      onItemSelected: (index) {
        print(index);
      },
      navBarStyle: NavBarStyle.style1,
    );
  }

  @override
  void dispose() {
    // Alle Offline Datenbanken schließen
    Hive.close();
    super.dispose();
  }
}

Widget _MaterialApp(BuildContext context, SharedPreferences prefs) {
  return MaterialApp(
    title: 'EJW Esslingen',
    home: MyHomePage(
        title: 'EJW Esslingen',
        isCacheEnabled: prefs.getBool("cache_pictures")),
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
    ),
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
