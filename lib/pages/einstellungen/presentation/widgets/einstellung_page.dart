import 'package:eje/pages/einstellungen/presentation/bloc/bloc.dart';
import 'package:eje/pages/einstellungen/presentation/bloc/einstellung_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EinstellungenPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SettingGroupTitle("Erscheinungsbild", context),
        CheckboxListTile(
          activeColor: Theme.of(context).accentColor,
          value: false,
          onChanged: (val) => BlocProvider.of<EinstellungBloc>(context).add(StoringPreferences("nightmode_auto", val)),
          title: Text(
            "Erscheinungsbild automatisch wählen",
          ),
          key: Key("nightmode_auto"),
        ),
        CheckboxListTile(
          activeColor: Theme.of(context).accentColor,
          value: true,
          onChanged: (val) => BlocProvider.of<EinstellungBloc>(context).add(StoringPreferences("notification_freizeiten", val)),
          title: Text(
            "Helles Erscheinungsbild",
          ),
          key: Key("nightmode_off"),
        ),
        CheckboxListTile(
          activeColor: Theme.of(context).accentColor,
          value: false,
          onChanged: (val) => BlocProvider.of<EinstellungBloc>(context).add(StoringPreferences("nightmode_on", val)),
          title: Text(
            "Dunkles Erscheinungsbild",
          ),
          key: Key("nightmode_on"),
        ),
        Divider(),
        SettingGroupTitle("Benachrichtigungen", context),
        CheckboxListTile(
          activeColor: Theme.of(context).accentColor,
          value: true,
          onChanged: (val) => BlocProvider.of<EinstellungBloc>(context).add(StoringPreferences("notification_on", val)),
          title: Text(
            "Benachrichtigungen aktivieren",
          ),
          key: Key("notifitcations_on"),
        ),
        SwitchListTile(
          activeColor: Theme.of(context).accentColor,
          value: true,
          onChanged: (val) => BlocProvider.of<EinstellungBloc>(context).add(StoringPreferences("notification_veranstaltungen", val)),
          title: Text(
            "Benachrichtigungen zu anstehenden Veranstaltungen erhalten",
          ),
          key: Key("notification_veranstaltungen"),
        ),
        SwitchListTile(
          activeColor: Theme.of(context).accentColor,
          value: true,
          onChanged:(val) => BlocProvider.of<EinstellungBloc>(context).add(StoringPreferences("notification_freizeiten", val)),
          title: Text(
            "Benachrichtigungen erhalten, wenn neue Freizeitanmeldungen online sind",
          ),
          key: Key("notification_freizeiten"),
        ),
        SwitchListTile(
          activeColor: Theme.of(context).accentColor,
          value: true,
          onChanged: (val) => BlocProvider.of<EinstellungBloc>(context).add(StoringPreferences("notification_neuigkeiten", val)),
          title: Text(
            "Benachrichtigungen erhalten, wenn es Neuigkeiten gibt",
          ),
          key: Key("notification_neuigkeiten"),
        ),
        Divider(),
        SettingGroupTitle("Internet", context),
        CheckboxListTile(
          activeColor: Theme.of(context).accentColor,
          value: true,
          onChanged: (val) => BlocProvider.of<EinstellungBloc>(context).add(StoringPreferences("only_wifi", val)),
          title: Text(
            "Inhalte nur über Wifi aktualisieren",
          ),
          key: Key("only_wifi"),
        ),
        CheckboxListTile(
          activeColor: Theme.of(context).accentColor,
          value: true,
          onChanged: (val) => BlocProvider.of<EinstellungBloc>(context).add(StoringPreferences("cache_pictures", val)),
          title: Text(
            "Heruntergeladene Bilder auf Gerät zwischenspeichern (reduziert Datenvolumen)",
          ),
          key: Key("cache_pictures"),
        ),
      ],
    );
  }
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