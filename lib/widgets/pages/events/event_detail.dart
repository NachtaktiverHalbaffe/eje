// ignore_for_file: non_constant_identifier_names, camel_case_types
import 'package:add_2_calendar/add_2_calendar.dart' as add2calendar;
import 'package:eje/models/event.dart';
import 'package:eje/utils/notificationplugin.dart';
import 'package:eje/utils/url_quick_launcher.dart';
import 'package:eje/widgets/alert_snackbar.dart';
import 'package:eje/widgets/details_page.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/no_result_card.dart';
import 'package:eje/widgets/pages/events/bloc/events_bloc.dart';
import 'package:eje/widgets/pages/events/bloc/events_event.dart';
import 'package:eje/widgets/pages/events/bloc/events_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class EventDetails extends StatelessWidget {
  final Event event;
  EventDetails(this.event);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state is Error) {
            AlertSnackbar(context).showErrorSnackBar(label: state.message);
            Navigator.pop(context);
          }
        },
        // ignore: missing_return
        builder: (context, state) {
          if (state is Empty) {
            print("Build page EventDetail: Empty");
            BlocProvider.of<EventsBloc>(context).add(GettingEvent(event.id));
            return Center();
          } else if (state is Loading) {
            print("Build page EventDetail: Loading");
            return LoadingIndicator();
          } else if (state is LoadedEvent) {
            print("Build page EventDetail: LoadedEvent");
            return EventDetailsCard(state.event);
          } else {
            print("Build page EventDetail: Undefined");
            AlertSnackbar(context).showErrorSnackBar(
                label:
                    "Konnte Details zur Veranstaltung nicht laden: Unbekannter Fehler");
            Navigator.pop(context);
            return NoResultCard(
                label:
                    "Konnte Details zum Veranstaltung nicht laden: Unbekannter Fehler",
                onRefresh: () async => BlocProvider.of<EventsBloc>(context)
                    .add(GettingEvent(event.id)));
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
      hyperlinks: List.empty(),
      childWidget: _terminChildWidget(event),
    );
  }
}

class _terminChildWidget extends StatelessWidget {
  final Event _termin;
  _terminChildWidget(this._termin);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
          trailing: GestureDetector(
            child: Icon(
              MdiIcons.calendar,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () async {
              var event = add2calendar.Event(
                title: _termin.name,
                description: _termin.description,
                location:
                    '${_termin.location.adress}, ${_termin.location.street}, ${_termin.location.postalCode}',
                startDate: _termin.startDate,
                endDate: _termin.endDate,
              );

              if (await Permission.calendarWriteOnly.isGranted) {
                print("Adding event to calendar");
                add2calendar.Add2Calendar.addEvent2Cal(event);
              } else {
                print(
                    "Calendar permissions not granted. Requesting permission");
                var status = await Permission.calendarWriteOnly.request();
                if (status == PermissionStatus.granted) {
                  add2calendar.Add2Calendar.addEvent2Cal(event);
                } else {
                  AlertSnackbar(context).showErrorSnackBar(
                      label:
                          "Termine können ohne Berechtigung nicht den Kalender hinzugefügt werden");
                }
              }
            },
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.mapMarker,
            size: 24,
            color: Theme.of(context).dividerColor,
          ),
          title: Text(
            "${_termin.location.adress}\n${_termin.location.street}\n${_termin.location.postalCode}",
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
              await MapsLauncher.launchQuery(
                  "${_termin.location.adress},${_termin.location.street}, ${_termin.location.postalCode}");
            },
          ),
        ),
        ListTile(
          leading: Icon(
            MdiIcons.cakeVariant,
            color: Theme.of(context).dividerColor,
            size: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          title: Text(
            "${_termin.ageFrom} - ${_termin.ageTo}",
            style: TextStyle(
              fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        _termin.price != 0 || _termin.price2 != 0
            ? ListTile(
                leading: Icon(
                  MdiIcons.currencyEur,
                  color: Theme.of(context).dividerColor,
                  size: 72 / MediaQuery.of(context).devicePixelRatio,
                ),
                title: Text(
                  _termin.price != 0
                      ? _termin.price.toString()
                      : _termin.price2.toString(),
                  style: TextStyle(
                    fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              )
            : Center(),
        SizedBox(
          height: 12,
        ),
        _termin.registrationLink != ""
            ? ListTile(
                leading: Icon(
                  MdiIcons.fileDocumentEditOutline,
                  color: Theme.of(context).dividerColor,
                  size: 72 / MediaQuery.of(context).devicePixelRatio,
                ),
                title: OutlinedButton(
                  onPressed: () =>
                      UrlQuickLauncher().openHttps(_termin.registrationLink),
                  child: Text(
                    "Anmelden \n(Anmeldeschluss:${DateFormat('dd.MM.yyyy').format(_termin.registrationEnd)})",
                    style: TextStyle(
                      color: Theme.of(context).dividerColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Center(),
        SizedBox(
          height: 36 / MediaQuery.of(context).devicePixelRatio,
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
        title: "Veranstaltungserinnerung",
        body:
            "Veranstaltung ${termin.name} findet am ${DateFormat('dd.MM.yyyy').format(termin.startDate)} statt",
        scheduleNotificationsDateTime: termin.startDate,
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
