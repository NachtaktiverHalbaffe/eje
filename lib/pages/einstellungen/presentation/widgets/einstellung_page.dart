import 'package:eje/core/widgets/alert_snackbar.dart';
import 'package:eje/core/widgets/bloc/bloc.dart';
import 'package:eje/core/widgets/costum_icons_icons.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:package_info_plus/package_info_plus.dart';

class EinstellungenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String groupID;
    final prefs = GetStorage();
    if (prefs.read("nightmode_auto")) {
      groupID = "nightmode_auto";
    } else if (prefs.read("nightmode_off")) {
      groupID = "nightmode_off";
    } else {
      groupID = "nightmode_on";
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        children: <Widget>[
          SettingGroupTitle("Erscheinungsbild"),
          RadioListTile(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: "nightmode_auto",
            groupValue: groupID,
            onChanged: (val) async {
              print("Setting Nightmode to auto");
              if (val == "nightmode_auto") {
                BlocProvider.of<EinstellungBloc>(context)
                    .add(StoringPreferences("nightmode_auto", true));
                BlocProvider.of<MainBloc>(context).add(ChangingThemeToAuto());
              } else {
                BlocProvider.of<EinstellungBloc>(context)
                    .add(StoringPreferences("nightmode_auto", false));
              }
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
            groupValue: groupID,
            onChanged: (val) async {
              print("Setting Nightmode to off");
              if (val == "nightmode_off") {
                BlocProvider.of<EinstellungBloc>(context)
                    .add(StoringPreferences("nightmode_off", true));
                BlocProvider.of<MainBloc>(context).add(ChangingThemeToLight());
              } else {
                BlocProvider.of<EinstellungBloc>(context)
                    .add(StoringPreferences("nightmode_off", false));
              }
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
            groupValue: groupID,
            onChanged: (val) async {
              print("Setting Nightmode to on");
              if (val == "nightmode_on") {
                BlocProvider.of<EinstellungBloc>(context)
                    .add(StoringPreferences("nightmode_on", true));
                BlocProvider.of<MainBloc>(context).add(ChangingThemeToDark());
              } else {
                BlocProvider.of<EinstellungBloc>(context)
                    .add(StoringPreferences("nightmode_on", false));
              }
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
            // activeColor: Theme.of(context).colorScheme.secondary,
            value: prefs.read("notifications_on"),
            onChanged: (val) async {
              if (!await Permission.notification.isGranted) {
                await Permission.notification.request();
              }
              BlocProvider.of<EinstellungBloc>(context)
                  .add(StoringPreferences("notifications_on", val!));
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
            value: prefs.read("notifications_veranstaltungen"),
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
            padding: EdgeInsets.only(left: 14, right: 22, top: 8, bottom: 8),
            child: TextField(
              controller: TextEditingController(
                  text: prefs.read("schedule_offset").toString()),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                if (int.parse(value) > 0 && int.parse(value) < 365) {
                  prefs.write("schedule_offset", int.parse(value));
                } else {
                  AlertSnackbar(context)
                      .showWarningSnackBar(label: "Ungültiger Zeitraum");
                }
              },
              decoration: InputDecoration(
                  floatingLabelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2.0,
                    ),
                  ),
                  labelText: 'Anzahl der Tage',
                  helperText:
                      "Tage vor der Veranstaltung, in der die Erinnerung kommen soll"),
            ),
          ),
          SwitchListTile(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: prefs.read("notifications_freizeiten"),
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
            value: prefs.read("notifications_neuigkeiten"),
            onChanged: (val) async {
              BlocProvider.of<EinstellungBloc>(context)
                  .add(StoringPreferences("notifications_neuigkeiten", val));
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
            value: prefs.read("only_wifi"),
            onChanged: (val) async {
              BlocProvider.of<EinstellungBloc>(context)
                  .add(StoringPreferences("only_wifi", val!));
            },
            title: Text(
              "Inhalte nur über WLAN aktualisieren",
              style: TextStyle(
                fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
              ),
            ),
            key: Key("only_wifi"),
          ),
          CheckboxListTile(
            value: prefs.read("cache_pictures"),
            onChanged: (val) async {
              BlocProvider.of<EinstellungBloc>(context)
                  .add(StoringPreferences("cache_pictures", val!));
            },
            title: Text(
              "Heruntergeladene Bilder auf Gerät zwischenspeichern (reduziert Datenvolumen-Verbrauch)",
              style: TextStyle(
                fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
              ),
            ),
            key: Key("cache_pictures"),
          ),
          Divider(),
          Container(
            margin: EdgeInsets.only(
              left: 25,
              right: 25,
              bottom: 24,
              top: 10,
            ),
            child: OutlinedButton(
              onPressed: () async {
                showAboutDialog(
                  context: context,
                  //TODO Update Appicon
                  applicationIcon: Icon(CostumIcons.eje),
                  applicationName: 'Über die App',
                  applicationVersion: await PackageInfo.fromPlatform()
                      .then((value) => value.version.toString()),
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
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () async {
                            if (await canLaunchUrlString(
                                "https://www.eje-esslingen.de/meta/datenschutz/")) {
                              await launchUrlString(
                                  "https://www.eje-esslingen.de/meta/datenschutz/");
                            } else {
                              throw 'Could not launch https://www.eje-esslingen.de/meta/datenschutz/';
                            }
                          },
                          child: Text(
                            "Datenschutz",
                            style: TextStyle(
                              fontSize:
                                  48 / MediaQuery.of(context).devicePixelRatio,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              child: Text(
                "Über",
              ),
            ),
          ),
        ],
      ),
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
