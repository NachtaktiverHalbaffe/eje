// ignore_for_file: non_constant_identifier_names

import 'package:eje/core/platform/Reminder.dart';
import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/core/utils/reminderManager.dart';
import 'package:eje/core/widgets/PrefImage.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_bloc.dart';
import 'package:eje/pages/termine/presentation/widgets/termineDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TerminCard extends StatelessWidget {
  final Termin termin;
  final String CHANNEL_NAME = "Erinnerungen an Veranstaltungen";
  final String CHANNEL_DESCRIPTION =
      "Erinnerung an eine Veranstaltung, die der Benutzer zum Merken ausgewählt hat";
  final String CHANNEL_ID = "1";

  TerminCard(this.termin);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
        boxShadow: [
          //background color of box
          BoxShadow(
            color: Colors.black,
            blurRadius: 20.0, // soften the shadow
            spreadRadius: 2.0, //extend the shadow
            offset: Offset(
              2, // Move to right 10  horizontally
              2, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: new BorderRadius.all(
            Radius.circular(54 / MediaQuery.of(context).devicePixelRatio)),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: sl<TermineBloc>(),
                child: TerminDetails(termin),
              ),
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 275,
                    color: Theme.of(context).cardColor,
                  ),
                  CachedImage(
                    url: termin.bild,
                    width: MediaQuery.of(context).size.width,
                    height: 275,
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 275,
                    color: Theme.of(context).cardColor,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 16),
                          Flexible(
                            child: Text(
                              termin.veranstaltung,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          SizedBox(width: 16),
                          Flexible(
                            child: Text(
                              termin.motto,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Divider(),
                      SizedBox(
                        height: 4,
                      ),
                      ListTile(
                        leading: Icon(
                          MdiIcons.calendar,
                          color: Theme.of(context).dividerColor,
                        ),
                        title: Text(
                          termin.datum,
                          style: TextStyle(
                              color: Theme.of(context).dividerColor,
                              fontSize: 16),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          MdiIcons.mapMarker,
                          color: Theme.of(context).dividerColor,
                        ),
                        title: Text(
                          termin.ort.Anschrift +
                              "\n" +
                              termin.ort.Strasse +
                              "\n" +
                              termin.ort.PLZ,
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).dividerColor),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      OutlinedButton(
                        onPressed: () async {
                          _setNotification();
                        },
                        child: Text(
                          "Veranstaltung merken",
                          style: TextStyle(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setNotification() async {
    final prefs = GetStorage();
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
}
