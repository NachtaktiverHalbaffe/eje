import 'package:eje/core/widgets/bloc/bloc.dart';
import 'package:eje/core/widgets/bloc/main_bloc.dart';
import 'package:eje/core/widgets/costum_icons_icons.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/bloc.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/einstellung_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Widget EinstellungenPage(BuildContext context, SharedPreferences prefs) {
  return ListView(
    children: <Widget>[
      SettingGroupTitle("Erscheinungsbild", context),
      CheckboxListTile(
        activeColor: Theme.of(context).accentColor,
        value: prefs.getBool("nightmode_auto"),
        onChanged: (val) async {
          print("Setting Nightmode to auto");
          await BlocProvider.of<EinstellungBloc>(context)
              .add(StoringPreferences("nightmode_auto", val));
          BlocProvider.of<MainBloc>(context).add(ChangingThemeToLight());
        },
        title: Text(
          "Erscheinungsbild automatisch wählen",
        ),
        key: Key("nightmode_auto"),
      ),
      CheckboxListTile(
        activeColor: Theme.of(context).accentColor,
        value: prefs.getBool("nightmode_off"),
        onChanged: (val) async {
          print("Setting Nightmode to off");
          await BlocProvider.of<EinstellungBloc>(context)
              .add(StoringPreferences("nightmode_off", val));
          BlocProvider.of<MainBloc>(context).add(ChangingThemeToLight());
        },
        title: Text(
          "Helles Erscheinungsbild",
        ),
        key: Key("nightmode_off"),
      ),
      CheckboxListTile(
        activeColor: Theme.of(context).accentColor,
        value: prefs.getBool("nightmode_on"),
        onChanged: (val) async {
          print("Setting Nightmode to on");
          await BlocProvider.of<EinstellungBloc>(context)
              .add(StoringPreferences("nightmode_on", val));
          BlocProvider.of<MainBloc>(context).add(ChangingThemeToAuto());
        },
        title: Text(
          "Dunkles Erscheinungsbild",
        ),
        key: Key("nightmode_on"),
      ),
      Divider(),
      SettingGroupTitle("Benachrichtigungen", context),
      CheckboxListTile(
        activeColor: Theme.of(context).accentColor,
        value: prefs.getBool("notifications_on"),
        onChanged: (val) async {
          await BlocProvider.of<EinstellungBloc>(context)
              .add(StoringPreferences("notifications_on", val));
        },
        title: Text(
          "Benachrichtigungen aktivieren",
        ),
        key: Key("notifitcations_on"),
      ),
      SwitchListTile(
        activeColor: Theme.of(context).accentColor,
        value: prefs.getBool("notifications_veranstaltungen"),
        onChanged: (val) async {
          await BlocProvider.of<EinstellungBloc>(context)
              .add(StoringPreferences("notifications_veranstaltungen", val));
        },
        title: Text(
          "Benachrichtigungen zu anstehenden Veranstaltungen erhalten",
        ),
        key: Key("notification_veranstaltungen"),
      ),
      SwitchListTile(
        activeColor: Theme.of(context).accentColor,
        value: prefs.getBool("notifications_freizeiten"),
        onChanged: (val) async {
          await BlocProvider.of<EinstellungBloc>(context)
              .add(StoringPreferences("notifications_freizeiten", val));
        },
        title: Text(
          "Benachrichtigungen erhalten, wenn neue Freizeitanmeldungen online sind",
        ),
        key: Key("notification_freizeiten"),
      ),
      SwitchListTile(
        activeColor: Theme.of(context).accentColor,
        value: prefs.getBool("notifications_neuigkeiten"),
        onChanged: (val) async {
          await BlocProvider.of<EinstellungBloc>(context)
              .add(StoringPreferences("notifications_neuigkeiten", val));
        },
        title: Text(
          "Benachrichtigungen erhalten, wenn es Neuigkeiten gibt",
        ),
        key: Key("notification_neuigkeiten"),
      ),
      Divider(),
      SettingGroupTitle("Internet", context),
      CheckboxListTile(
        activeColor: Theme.of(context).accentColor,
        value: prefs.getBool("only_wifi"),
        onChanged: (val) async {
          await BlocProvider.of<EinstellungBloc>(context)
              .add(StoringPreferences("only_wifi", val));
        },
        title: Text(
          "Inhalte nur über Wifi aktualisieren",
        ),
        key: Key("only_wifi"),
      ),
      CheckboxListTile(
        activeColor: Theme.of(context).accentColor,
        value: prefs.getBool("cache_pictures"),
        onChanged: (val) async {
          await BlocProvider.of<EinstellungBloc>(context)
              .add(StoringPreferences("cache_pictures", val));
        },
        title: Text(
          "Heruntergeladene Bilder auf Gerät zwischenspeichern (reduziert Datenvolumen)",
        ),
        key: Key("cache_pictures"),
      ),
      Divider(),
      SettingGroupTitle("Über", context),
      Container(
        margin: EdgeInsets.only(
          left: 25.0,
          right: 25.0,
          bottom: 24.0,
          top: 10.0,
        ),
        child: OutlineButton(
          onPressed: () {
            showAboutDialog(
              context: context,
              //TODO Update Appicon
              applicationIcon: Icon(CostumIcons.eje),
              applicationName: 'Über die App',
              applicationVersion: 'Pre-Release',
              applicationLegalese: 'Entwickelt vom LeMonkay VT&IT',
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(
                      height: 40 / MediaQuery.of(context).devicePixelRatio,
                    ),
                    Text(
                      'Inhaltliche Administration durch das Evang. Jugendwerk Bezirk Esslingen',
                    ),
                    SizedBox(
                      height: 60 / MediaQuery.of(context).devicePixelRatio,
                    ),
                    OutlineButton(
                      onPressed: () async {
                        if (await canLaunch(
                            "https://www.eje-esslingen.de/meta/datenschutz/")) {
                          await launch(
                              "https://www.eje-esslingen.de/meta/datenschutz/");
                        } else {
                          throw 'Could not launch https://www.eje-esslingen.de/meta/datenschutz/';
                        }
                      },
                      child: Text(
                        "Datenschutz",
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ],
                ),
              ],
            );
          },
          child: Text(
            "Über die App, Datenschutz und Lizenzen",
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ],
  );
}

Widget SettingGroupTitle(String title, BuildContext context) {
  final titleleft = 16.0;
  final titletop = 12.0;
  final titlebottom = 0.0;
  return Container(
    width: MediaQuery.of(context).size.width,
    padding:
        EdgeInsets.only(left: titleleft, top: titletop, bottom: titlebottom),
    child: Text(
      title,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Theme.of(context).accentColor,
        fontSize: 16,
      ),
    ),
  );
}
