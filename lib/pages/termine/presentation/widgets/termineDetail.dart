import 'package:eje/core/platform/Reminder.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/core/utils/reminderManager.dart';
import 'package:eje/core/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:eje/pages/termine/presentation/bloc/bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TerminDetails extends StatefulWidget {
  final Termin termin;
  final bool isCacheEnabled;
  final SharedPreferences prefs;

  TerminDetails(this.termin, this.isCacheEnabled, this.prefs);

  @override
  _TerminDetailsState createState() =>
      _TerminDetailsState(isCacheEnabled, termin, prefs);
}

class _TerminDetailsState extends State<TerminDetails> {
  final bool isCacheEnabled;
  final Termin termin;
  final SharedPreferences prefs;

  _TerminDetailsState(this.isCacheEnabled, this.termin, this.prefs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TermineBloc, TermineState>(listener: (context, state) {
        if (state is Error) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
          // ignore: missing_return
          builder: (context, state) {
        if (state is Loading) {
          return LoadingIndicator();
        } else if (state is LoadedTermin) {
          return TerminDetailsCard(
              state.termin, widget.isCacheEnabled, context, prefs);
        }
      }),
    );
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<TermineBloc>(context)
        .add(GettingTermin(termin.veranstaltung, termin.datum));
  }
}

Widget TerminDetailsCard(Termin termin, bool isCacheEnabled,
    BuildContext context, SharedPreferences prefs) {
  List<String> bilder = List();
  bilder.add(termin.bild);
  return DetailsPage(
    titel: termin.veranstaltung,
    untertitel: termin.motto,
    text: termin.text,
    bild_url: bilder,
    hyperlinks: [Hyperlink(link: "", description: "")],
    childWidget: _terminChildWidget(termin, context, prefs),
  );
}

Widget _terminChildWidget(
    Termin _termin, BuildContext context, SharedPreferences prefs) {
  return Column(
    children: [
      SizedBox(height: 12),
      Divider(),
      ListTile(
        leading: Icon(
          Icons.today,
          size: 24,
        ),
        title: Text(
          _termin.datum,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.mapMarker,
          size: 24,
        ),
        title: Text(
          _termin.ort.Anschrift +
              "\n" +
              _termin.ort.Strasse +
              "\n" +
              _termin.ort.PLZ,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
        dense: true,
      ),
      SizedBox(
        height: 12,
      ),
      Container(
        margin: EdgeInsets.all(8),
        child: OutlineButton(
          onPressed: () async {
            _setNotification(_termin, prefs);
          },
          child: Text("Veranstaltung merken"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      SizedBox(
        height: 12,
      ),
    ],
  );
}

void _setNotification(Termin termin, SharedPreferences prefs) async {
  final String CHANNEL_NAME = "Erinnerungen an Veranstaltungen";
  final String CHANNEL_DESCRIPTION =
      "Erinnerung an eine Veranstaltung, die der Benutzer zum Merken ausgewählt hat";
  final String CHANNEL_ID = "1";
  await ReminderManager().setReminder(
    Reminder(
        kategorie: "Termin",
        //date: termin.datum,
        identifier: termin.veranstaltung,
        notificationtext:
            "Erinnerung: " + termin.veranstaltung + " findet morgen statt "),
  );
  // Notification schedulen
  if (prefs.getBool("notifications_on")) {
    if (prefs.getBool("notifications_veranstaltungen")) {
      List<Reminder> _reminder = await ReminderManager().getAllReminder();
      await notificationPlugin.scheduledNotification(
        id: _reminder.length,
        title: "Erinnerung",
        body: "Erinnerung: Veranstaltung " +
            termin.veranstaltung +
            " findet am " +
            termin.datum +
            " statt",
        scheduleNotificationsDateTime:
            DateTime.now().add(Duration(days: 1, seconds: 5)),
        payload: "2",
        channelDescription: CHANNEL_DESCRIPTION,
        channelId: CHANNEL_ID,
        channelName: CHANNEL_NAME,
      );
    } else
      notificationPlugin.showNotification(
          id: 0,
          payload: "4",
          title: "Benachrichtigungen für Veranstaltungen nicht aktiviert",
          body: "Diese Funktion muss in den Einstellungen aktiviert werden",
          channelId: "0",
          channelName: "App-Benachrichtigungen",
          channelDescription:
              "Grundlegende Benachrichtigungen von der App über Appfunktionen");
  } else
    notificationPlugin.showNotificationsDisabled();
}
