import 'package:eje/core/widgets/eje_logo_icons.dart';
import 'package:eje/pages/einstellungen/einstellungen.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/eje.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:eje/pages/instagram/instagram.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:persistent_bottom_nav_bar/models/persisten-bottom-nav-item.widget.dart';
import 'package:persistent_bottom_nav_bar/models/persistent-bottom-nav-bar-styles.widget.dart';
import 'package:persistent_bottom_nav_bar/models/persistent-nav-bar-scaffold.widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/neuigkeiten/neuigkeiten.dart';
import 'utils/first_startup.dart';
import 'utils/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await prefStartup();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(NeuigkeitAdapter());
  Hive.registerAdapter(HauptamtlicherAdapter());
  Hive.registerAdapter(BAKlerAdapter());
  Hive.registerAdapter(ArbeitsbereichAdapter());
  await di.init();
  runApp(MyApp(await SharedPreferences.getInstance()));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  MyApp(this.prefs); // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EJW Esslingen',
      home: MyHomePage(title: 'EJW Esslingen', isCacheEnabled:prefs.getBool("cache_pictures")),
      //TODO Theming: Selected Text Item
      theme: ThemeData.light().copyWith(
        // Firmenfarbe
        accentColor: Color(0xFFCD2E32),
        //Textcolors
        primaryTextTheme: Typography(platform: TargetPlatform.android).black,
        textTheme: Typography(platform: TargetPlatform.android).black,
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
        backgroundColor: Colors.black45,
      ),
      themeMode: prefs.getBool("nightmode_auto")
          ? ThemeMode.system
          : prefs.getBool("nightmode_on") ? ThemeMode.dark : ThemeMode.light,
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
        icon: Icon(EjeLogo.ejeLogo),
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
      Instagram(),
      Center(),
      Einstellungen()
    ];
  }


  @override
  Widget build(BuildContext context) {

    return PersistentTabView(
      controller: PersistentTabController(initialIndex: 0),
      items: _navBarsItems(),
      screens: _buildScreens(),
      showElevation: true,
      backgroundColor:Theme.of(context).backgroundColor,
      iconSize: 26.0,
      navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property
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
