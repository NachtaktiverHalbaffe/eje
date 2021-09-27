// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'package:eje/core/platform/MapLauncher.dart';
import 'package:eje/core/utils/notificationplugin.dart';
import 'package:eje/pages/articles/presentation/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/termine/domain/entities/Event.dart';
import 'package:eje/pages/termine/presentation/bloc/bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/events_bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/events_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventDetails extends StatelessWidget {
  final Event event;
  EventDetails(this.event);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TermineBloc, EventsState>(
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
            BlocProvider.of<TermineBloc>(context).add(GettingEvent(event.id));
            return LoadingIndicator();
          } else if (state is Loading) {
            print("Build page EventDetail: Loading");
            return LoadingIndicator();
          } else if (state is LoadedEvent) {
            print("Build page EventDetail: LoadedEvent");
            return EventDetailsCard(state.event);
          } else {
            print("Build page EventDetail: Undefined");

            return LoadingIndicator();
          }
        },
      ),
    );
  }
}

class EventDetailsCard extends StatelessWidget {
  final Event event;
  EventDetailsCard(this.event);

  @override
  Widget build(BuildContext context) {
    return DetailsPage(
      titel: event.name,
      untertitel: event.motto,
      text: event.description,
      bilder: event.images,
      hyperlinks: [Hyperlink(link: "", description: "")],
      childWidget: _terminChildWidget(event),
    );
  }
}

class _terminChildWidget extends StatelessWidget {
  final Event _termin;
  _terminChildWidget(this._termin);
  // TODO ICAL implementierung
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
            DateFormat('dd.MM.yyyy').format(_termin.startDate),
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
            _termin.location.adress +
                "\n" +
                _termin.location.street +
                "\n" +
                _termin.location.postalCode,
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
              await MapLauncher.launchQuery(_termin.location.adress +
                  "," +
                  _termin.location.street +
                  ", " +
                  _termin.location.postalCode);
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

void _setNotification(Event termin) async {
  final prefs = GetStorage();
  final String CHANNEL_NAME = "Erinnerungen an Veranstaltungen";
  final String CHANNEL_DESCRIPTION =
      "Erinnerung an eine Veranstaltung, die der Benutzer zum Merken ausgewählt hat";
  final String CHANNEL_ID = "1";

  var notfScheduled = prefs.read('notifications_scheduled');
  prefs.write('notifications_scheduled', notfScheduled++);
  // Notification schedulen
  if (prefs.read("notifications_on")) {
    if (prefs.read("notifications_veranstaltungen")) {
      await notificationPlugin.scheduledNotification(
        id: prefs.read('notifications_scheduled'),
        title: "Erinnerung",
        body: "Erinnerung: Veranstaltung " +
            termin.name +
            " findet am " +
            DateFormat('dd.MM.yyyy').format(termin.startDate) +
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
