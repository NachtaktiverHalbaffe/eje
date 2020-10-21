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
  final SharedPreferences prefs;

  TerminCard(this.termin, this.isCacheEnabled, this.prefs);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: new BorderRadius.all(
          Radius.circular(54 / MediaQuery.of(context).devicePixelRatio)),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: sl<TermineBloc>(),
              child: TerminDetails(termin, isCacheEnabled, prefs),
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
                              fontSize:
                                  54 / MediaQuery.of(context).devicePixelRatio,
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
                      leading: Icon(MdiIcons.calendar),
                      title: Text(
                        termin.datum,
                        style: TextStyle(
                            fontSize:
                                48 / MediaQuery.of(context).devicePixelRatio),
                      ),
                    ),
                    ListTile(
                      leading: Icon(MdiIcons.mapMarker),
                      title: Text(
                        termin.ort.Anschrift +
                            "\n" +
                            termin.ort.Strasse +
                            "\n" +
                            termin.ort.PLZ,
                        style: TextStyle(
                            fontSize:
                                45 / MediaQuery.of(context).devicePixelRatio),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    OutlineButton(
                      onPressed: () async {
                        await _setNotification();
                      },
                      child: Text("Veranstaltung merken"),
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
    );
  }

  void _setNotification() async {
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
}
