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
    return ClipRRect(
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
                  height: 825 / MediaQuery.of(context).devicePixelRatio,
                  color: Theme.of(context).cardColor,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 825 / MediaQuery.of(context).devicePixelRatio,
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
                  height: 825 / MediaQuery.of(context).devicePixelRatio,
                  color: Theme.of(context).cardColor,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 36 / MediaQuery.of(context).devicePixelRatio,
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width:
                                48 / MediaQuery.of(context).devicePixelRatio),
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
                        SizedBox(
                            width:
                                48 / MediaQuery.of(context).devicePixelRatio),
                        Flexible(
                          child: Text(
                            termin.motto,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize:
                                  56 / MediaQuery.of(context).devicePixelRatio,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 36 / MediaQuery.of(context).devicePixelRatio,
                    ),
                    Divider(),
                    SizedBox(
                      height: 12 / MediaQuery.of(context).devicePixelRatio,
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
                                44 / MediaQuery.of(context).devicePixelRatio),
                      ),
                    ),
                    SizedBox(
                      height: 18 / MediaQuery.of(context).devicePixelRatio,
                    ),
                    OutlineButton(
                      onPressed: () async {
                        await ReminderManager().setReminder(
                          Reminder(
                              kategorie: "Termin",
                              //date: termin.datum,
                              identifier: termin.veranstaltung,
                              notificationtext: "Erinnerung: " +
                                  termin.veranstaltung +
                                  " findet morgen statt "),
                        );
                        // Notification schedulen
                        List<Reminder> _reminder =
                            await ReminderManager().getAllReminder();
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
                          payload: "Termin",
                          channelDescription: CHANNEL_DESCRIPTION,
                          channelId: CHANNEL_ID,
                          channelName: CHANNEL_NAME,
                        );
                      },
                      child: Text("Veranstaltung merken"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              36 / MediaQuery.of(context).devicePixelRatio)),
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
}
