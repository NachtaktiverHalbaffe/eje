// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:eje/core/platform/Reminder.dart';
import 'package:eje/core/utils/MapLauncher.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/core/utils/reminderManager.dart';
import 'package:eje/pages/articles/presentation/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:eje/pages/termine/presentation/bloc/bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TerminDetails extends StatelessWidget {
  final Termin termin;
  TerminDetails(this.termin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TermineBloc, TermineState>(
        listener: (context, state) {
          if (state is Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        // ignore: missing_return
        builder: (context, state) {
          if (state is Empty) {
            print("Build page EventDetail: Empty");
            BlocProvider.of<TermineBloc>(context)
                .add(GettingTermin(termin.veranstaltung, termin.datum));
            return LoadingIndicator();
          } else if (state is Loading) {
            print("Build page EventDetail: Loading");
            return LoadingIndicator();
          } else if (state is LoadedTermin) {
            print("Build page EventDetail: LoadedEvent");
            return TerminDetailsCard(state.termin);
          } else {
            print("Build page EventDetail: Undefined");
            BlocProvider.of<TermineBloc>(context)
                .add(GettingTermin(termin.veranstaltung, termin.datum));
            return LoadingIndicator();
          }
        },
      ),
    );
  }
}

class TerminDetailsCard extends StatelessWidget {
  final Termin termin;
  TerminDetailsCard(this.termin);

  @override
  Widget build(BuildContext context) {
    List<String> bilder = List.empty(growable: true);
    bilder.add(termin.bild);
    return DetailsPage(
      titel: termin.veranstaltung,
      untertitel: termin.motto,
      text: termin.text,
      bilder: bilder,
      hyperlinks: [Hyperlink(link: "", description: "")],
      childWidget: _terminChildWidget(termin),
    );
  }
}

class _terminChildWidget extends StatelessWidget {
  final Termin _termin;
  _terminChildWidget(this._termin);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        Divider(),
        ListTile(
          leading: Icon(
            Icons.today,
            size: 24,
            color: Theme.of(context).dividerColor,
          ),
          title: Text(
            _termin.datum,
            style: TextStyle(
              fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.mapMarker,
            size: 24,
            color: Theme.of(context).dividerColor,
          ),
          title: Text(
            _termin.ort.Anschrift +
                "\n" +
                _termin.ort.Strasse +
                "\n" +
                _termin.ort.PLZ,
            style: TextStyle(
              fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
              color: Theme.of(context).dividerColor,
            ),
          ),
          dense: true,
          trailing: GestureDetector(
            child: Icon(
              MdiIcons.navigation,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () async {
              await MapLauncher.launchQuery(_termin.ort.Anschrift +
                  "," +
                  _termin.ort.Strasse +
                  ", " +
                  _termin.ort.PLZ);
            },
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Container(
          margin: EdgeInsets.all(8),
          child: OutlinedButton(
            onPressed: () async {
              _setNotification(_termin);
            },
            child: Text(
              "Veranstaltung merken",
              style: TextStyle(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}

void _setNotification(Termin termin) async {
  final prefs = GetStorage();
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
  if (prefs.read("notifications_on")) {
    if (prefs.read("notifications_veranstaltungen")) {
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
        scheduleoffest: Duration(days: prefs.read("schedule_offset")),
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
