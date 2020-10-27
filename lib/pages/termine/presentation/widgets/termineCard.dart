import 'package:eje/core/platform/Reminder.dart';
import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/core/utils/reminderManager.dart';
import 'package:eje/pages/termine/domain/entities/Termin.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_bloc.dart';
import 'package:eje/pages/termine/presentation/widgets/termineDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TerminCard extends StatelessWidget {
  final Termin termin;
  final bool isCacheEnabled;
  final String CHANNEL_NAME = "Erinnerungen an Veranstaltungen";
  final String CHANNEL_DESCRIPTION =
      "Erinnerung an eine Veranstaltung, die der Benutzer zum Merken ausgewählt hat";
  final String CHANNEL_ID = "1";

  TerminCard(this.termin, this.isCacheEnabled);

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
                child: TerminDetails(termin, isCacheEnabled),
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 275,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: ExactAssetImage(termin.bild),
                      ),
                    ),
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
                                  fontSize: 84 /
                                      MediaQuery.of(context).devicePixelRatio,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor),
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
                                fontSize: 54 /
                                    MediaQuery.of(context).devicePixelRatio,
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
                              fontSize:
                                  48 / MediaQuery.of(context).devicePixelRatio),
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
                              fontSize:
                                  45 / MediaQuery.of(context).devicePixelRatio,
                              color: Theme.of(context).dividerColor),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      OutlineButton(
                        color: Theme.of(context).dividerColor,
                        onPressed: () async {
                          await _setNotification();
                        },
                        child: Text(
                          "Veranstaltung merken",
                          style: TextStyle(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
          scheduleoffest: Duration(days: prefs.getInt("schedule_offset")),
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
