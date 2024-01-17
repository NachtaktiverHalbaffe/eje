// ignore_for_file: non_constant_identifier_names
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eje/models/Event.dart';
import 'package:eje/utils/injection_container.dart';
import 'package:eje/utils/notificationplugin.dart';
import 'package:eje/widgets/cached_image.dart';
import 'package:eje/widgets/pages/events/bloc/events_bloc.dart';
import 'package:eje/widgets/pages/events/event_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final String CHANNEL_NAME = "Erinnerungen an Veranstaltungen";
  final String CHANNEL_DESCRIPTION =
      "Erinnerung an eine Veranstaltung, die der Benutzer zum Merken ausgewählt hat";
  final String CHANNEL_ID = "1";

  EventCard(this.event);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
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
        borderRadius: BorderRadius.all(
            Radius.circular(54 / MediaQuery.of(context).devicePixelRatio)),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: diContainer<EventsBloc>(),
                child: EventDetails(event),
              ),
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    color: Theme.of(context).cardColor,
                  ),
                  CachedImage(
                    url: event.images[0],
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 325,
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
                            child: AutoSizeText(
                              event.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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
                            child: AutoSizeText(
                              event.motto,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 16)
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          MdiIcons.calendar,
                          color: Theme.of(context).dividerColor,
                        ),
                        title: Text(
                          DateFormat('dd.MM.yyyy').format(event.startDate),
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
                          "${event.location.adress}\n${event.location.street}\n${event.location.postalCode}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).dividerColor),
                        ),
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
    var notfScheduled = prefs.read('notifications_scheduled');
    prefs.write('notifications_scheduled', notfScheduled++);

    // Notification schedulen
    if (prefs.read("notifications_on")) {
      if (prefs.read("notifications_veranstaltungen")) {
        await notificationPlugin.scheduledNotification(
          id: prefs.read('notifications_scheduled'),
          title: "Erinnerung",
          body:
              "Erinnerung: Veranstaltung ${event.name} findet am ${DateFormat('dd.MM.yyyy').format(event.startDate)} statt",
          scheduleNotificationsDateTime: event.startDate,
          scheduleoffest: Duration(days: prefs.read("schedule_offset")),
          payload: "2",
          channelDescription: CHANNEL_DESCRIPTION,
          channelId: CHANNEL_ID,
          channelName: CHANNEL_NAME,
        );
      } else {
        notificationPlugin.showNotification(
            id: 0,
            payload: "4",
            title: "Benachrichtigungen für Veranstaltungen nicht aktiviert",
            body: "Diese Funktion muss in den Einstellungen aktiviert werden",
            channelId: "0",
            channelName: "App-Benachrichtigungen",
            channelDescription:
                "Grundlegende Benachrichtigungen von der App über Appfunktionen");
      }
    } else {
      notificationPlugin.showNotificationsDisabled();
    }
  }
}
