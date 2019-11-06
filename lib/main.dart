import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'bloc/neuigkeiten/neuigkeiten_bloc.dart';
import 'database/neuigkeiten/neuigkeit.dart';
import 'pages/neuigkeiten.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EJW Esslingen',
      home: MyHomePage(title: 'EJW Esslingen'),
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
      ),
      darkTheme: ThemeData.dark().copyWith(
        //Firmenfarbe
        accentColor: Color(0xFFCD2E32),
        //Textcolors
        textSelectionColor: Theme.of(context).accentColor,
        //Iconcolors und Widgetcolors
        dividerColor: Colors.white,
      ),
      themeMode: ThemeMode.dark,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _selectedItem = 0;

  _fragmentmanager(int pos) {
    switch (pos) {
      case 0:
        return Neuigkeiten();
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedItem = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    const double groupTitlePaddingLeft = 12;
    const double groupTitlePaddingTop = 10;
    const double groupTitlePaddingDown = 8;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.title,
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          leading: IconButton(
            icon: Icon(MdiIcons.menu),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        drawer: Drawer(
          child: new ListView(
            children: <Widget>[
              new DrawerHeader(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.fitWidth,
                      alignment: FractionalOffset.bottomCenter,
                      image: new ExactAssetImage(
                          "assets/images/eje_transparent_header.gif")),
                ),
                child: null,
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    left: groupTitlePaddingLeft,
                    top: groupTitlePaddingTop,
                    bottom: groupTitlePaddingDown),
                child: Text(
                  "Das Jugendwerk",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              new ListTile(
                title: Text("Neuigkeiten"),
                leading: Icon(
                  MdiIcons.newspaper,
                  color: Theme.of(context).dividerColor,
                ),
                selected: 0 == _selectedItem,
                onTap: () => _onSelectItem(0),
              ),
              new ListTile(
                title: Text("FAQ"),
                leading: Icon(
                  Icons.question_answer,
                  color: Theme.of(context).dividerColor,
                ),
                selected: 1 == _selectedItem,
                onTap: () => _onSelectItem(1),
              ),
              new ListTile(
                title: Text("Die Hauptamtlichen"),
                leading: Icon(
                  Icons.work,
                  color: Theme.of(context).dividerColor,
                ),
                selected: 2 == _selectedItem,
                onTap: () => _onSelectItem(2),
              ),
              new ListTile(
                title: Text("Der BAK"),
                leading: Icon(
                  Icons.account_box,
                  color: Theme.of(context).dividerColor,
                ),
                selected: 3 == _selectedItem,
                onTap: () => _onSelectItem(3),
              ),
              new ListTile(
                title: Text("Arbeitsfelder"),
                leading: Icon(
                  MdiIcons.sitemap,
                  color: Theme.of(context).dividerColor,
                ),
                selected: 4 == _selectedItem,
                onTap: () => _onSelectItem(4),
              ),
              new ListTile(
                title: Text("Instagram"),
                leading: Icon(
                  MdiIcons.instagram,
                  color: Theme.of(context).dividerColor,
                ),
                selected: 5 == _selectedItem,
                onTap: () => _onSelectItem(5),
              ),
              new Divider(),
              new Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    left: groupTitlePaddingLeft,
                    top: groupTitlePaddingTop,
                    bottom: groupTitlePaddingDown),
                child: Text(
                  "Angebote",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              new ListTile(
                title: Text("Freizeiten"),
                leading: Icon(
                  Icons.terrain,
                  color: Theme.of(context).dividerColor,
                ),
                selected: 6 == _selectedItem,
                onTap: () => _onSelectItem(6),
              ),
              new ListTile(
                title: Text("Veranstaltungen"),
                leading: Icon(
                  Icons.today,
                  color: Theme.of(context).dividerColor,
                ),
                selected: 7 == _selectedItem,
                onTap: () => _onSelectItem(7),
              ),
              new Divider(),
              new Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    left: groupTitlePaddingLeft,
                    top: groupTitlePaddingTop,
                    bottom: groupTitlePaddingDown),
                child: Text(
                  "App",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              new ListTile(
                title: Text("Einstellungen"),
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).dividerColor,
                ),
                selected: 8 == _selectedItem,
                onTap: () => _onSelectItem(8),
              ),
              new ListTile(
                title: Text("Über"),
                leading: Icon(
                  Icons.info,
                  color: Theme.of(context).dividerColor,
                ),
                selected: 9 == _selectedItem,
                onTap: () => _onSelectItem(9),
              ),
            ],
          ),
        ),
        body: _fragmentmanager(_selectedItem));
  }
}
