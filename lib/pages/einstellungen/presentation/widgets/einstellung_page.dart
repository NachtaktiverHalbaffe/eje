import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/core/widgets/bloc/bloc.dart';
import 'package:eje/core/widgets/bloc/main_bloc.dart';
import 'package:eje/core/widgets/costum_icons_icons.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/bloc.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/einstellung_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EinstellungenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _groupID;
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.getBool("nightmode_auto")) {
            _groupID = "nightmode_auto";
          } else if (snapshot.data.getBool("nightmode_off")) {
            _groupID = "nightmode_off";
          } else {
            _groupID = "nightmode_on";
          }

          return ListView(
            children: <Widget>[
              SettingGroupTitle("Erscheinungsbild"),
              RadioListTile(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: "nightmode_auto",
                groupValue: _groupID,
                onChanged: (val) async {
                  print("Setting Nightmode to auto");
                  val == "nightmode_auto"
                      ? BlocProvider.of<EinstellungBloc>(context)
                          .add(StoringPreferences("nightmode_auto", true))
                      : BlocProvider.of<EinstellungBloc>(context)
                          .add(StoringPreferences("nightmode_auto", false));
                  BlocProvider.of<MainBloc>(context)
                      .add(ChangingThemeToLight());
                },
                title: Text(
                  "Erscheinungsbild automatisch wählen",
                  style: TextStyle(
                    fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
                  ),
                ),
                key: Key("nightmode_auto"),
              ),
              RadioListTile(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: "nightmode_off",
                groupValue: _groupID,
                onChanged: (val) async {
                  print("Setting Nightmode to off");
                  val == "nightmode_off"
                      ? BlocProvider.of<EinstellungBloc>(context)
                          .add(StoringPreferences("nightmode_off", true))
                      : BlocProvider.of<EinstellungBloc>(context)
                          .add(StoringPreferences("nightmode_off", false));
                  BlocProvider.of<MainBloc>(context)
                      .add(ChangingThemeToLight());
                },
                title: Text(
                  "Helles Erscheinungsbild",
                  style: TextStyle(
                    fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
                  ),
                ),
                key: Key("nightmode_off"),
              ),
              RadioListTile(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: "nightmode_on",
                groupValue: _groupID,
                onChanged: (val) async {
                  print("Setting Nightmode to on");
                  val == "nightmode_on"
                      ? BlocProvider.of<EinstellungBloc>(context)
                          .add(StoringPreferences("nightmode_on", true))
                      : BlocProvider.of<EinstellungBloc>(context)
                          .add(StoringPreferences("nightmode_on", false));
                  BlocProvider.of<MainBloc>(context).add(ChangingThemeToAuto());
                },
                title: Text(
                  "Dunkles Erscheinungsbild",
                  style: TextStyle(
                    fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
                  ),
                ),
                key: Key("nightmode_on"),
              ),
              Divider(),
              SettingGroupTitle("Benachrichtigungen"),
              CheckboxListTile(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: snapshot.data.getBool("notifications_on"),
                onChanged: (val) async {
                  BlocProvider.of<EinstellungBloc>(context)
                      .add(StoringPreferences("notifications_on", val));
                },
                title: Text(
                  "Benachrichtigungen aktivieren",
                  style: TextStyle(
                    fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
                  ),
                ),
                key: Key("notifitcations_on"),
              ),
              SwitchListTile(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: snapshot.data.getBool("notifications_veranstaltungen"),
                onChanged: (val) async {
                  BlocProvider.of<EinstellungBloc>(context).add(
                      StoringPreferences("notifications_veranstaltungen", val));
                },
                title: Text(
                  "Benachrichtigungen zu anstehenden Veranstaltungen erhalten",
                  style: TextStyle(
                    fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
                  ),
                ),
                key: Key("notification_veranstaltungen"),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 14, right: 22, top: 8, bottom: 8),
                child: TextField(
                  controller: TextEditingController(text: '1'),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) =>
                      snapshot.data.setInt("schedule_offset", int.parse(value)),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Anzahl der Tage',
                      helperText:
                          "Tage vor der Veranstaltung, in der die Erinnerung kommen soll"),
                ),
              ),
              SwitchListTile(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: snapshot.data.getBool("notifications_freizeiten"),
                onChanged: (val) async {
                  BlocProvider.of<EinstellungBloc>(context)
                      .add(StoringPreferences("notifications_freizeiten", val));
                },
                title: Text(
                  "Benachrichtigungen erhalten, wenn neue Freizeitanmeldungen online sind",
                  style: TextStyle(
                    fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
                  ),
                ),
                key: Key("notification_freizeiten"),
              ),
              SwitchListTile(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: snapshot.data.getBool("notifications_neuigkeiten"),
                onChanged: (val) async {
                  BlocProvider.of<EinstellungBloc>(context).add(
                      StoringPreferences("notifications_neuigkeiten", val));
                },
                title: Text(
                  "Benachrichtigungen erhalten, wenn es Neuigkeiten gibt",
                  style: TextStyle(
                    fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
                  ),
                ),
                key: Key("notification_neuigkeiten"),
              ),
              Divider(),
              SettingGroupTitle("Internet"),
              CheckboxListTile(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: snapshot.data.getBool("only_wifi"),
                onChanged: (val) async {
                  BlocProvider.of<EinstellungBloc>(context)
                      .add(StoringPreferences("only_wifi", val));
                },
                title: Text(
                  "Inhalte nur über Wifi aktualisieren",
                  style: TextStyle(
                    fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
                  ),
                ),
                key: Key("only_wifi"),
              ),
              CheckboxListTile(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: snapshot.data.getBool("cache_pictures"),
                onChanged: (val) async {
                  BlocProvider.of<EinstellungBloc>(context)
                      .add(StoringPreferences("cache_pictures", val));
                },
                title: Text(
                  "Heruntergeladene Bilder auf Gerät zwischenspeichern (reduziert Datenvolumen)",
                  style: TextStyle(
                    fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
                  ),
                ),
                key: Key("cache_pictures"),
              ),
              Divider(),
              SettingGroupTitle("Über"),
              Container(
                margin: EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: 24,
                  top: 10,
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
                              height:
                                  40 / MediaQuery.of(context).devicePixelRatio,
                            ),
                            Text(
                              'Inhaltliche Administration durch das Evang. Jugendwerk Bezirk Esslingen',
                            ),
                            SizedBox(
                              height:
                                  60 / MediaQuery.of(context).devicePixelRatio,
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
                                style: TextStyle(
                                  fontSize: 48 /
                                      MediaQuery.of(context).devicePixelRatio,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(36 /
                                      MediaQuery.of(context).devicePixelRatio)),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  child: Text(
                    "Über",
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          36 / MediaQuery.of(context).devicePixelRatio)),
                ),
              ),
            ],
          );
        } else
          return LoadingIndicator();
      },
    );
  }
}

class SettingGroupTitle extends StatelessWidget {
  final String title;
  final titleleft = 16.0;
  final titletop = 12.0;
  final titlebottom = 0.0;
  SettingGroupTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding:
          EdgeInsets.only(left: titleleft, top: titletop, bottom: titlebottom),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 54 / MediaQuery.of(context).devicePixelRatio,
        ),
      ),
    );
  }
}
