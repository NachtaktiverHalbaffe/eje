import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:eje/models/camp.dart';
import 'package:eje/utils/url_quick_launcher.dart';
import 'package:eje/widgets/alert_snackbar.dart';
import 'package:eje/widgets/details_page.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/no_result_card.dart';
import 'package:eje/widgets/pages/camps/bloc/camps_bloc.dart';
import 'package:eje/widgets/pages/camps/bloc/camps_event.dart';
import 'package:eje/widgets/pages/camps/bloc/camps_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CampDetails extends StatelessWidget {
  final Camp camp;
  CampDetails(this.camp);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CampsBloc, CampState>(listener: (context, state) {
        if (state is Error) {
          AlertSnackbar(context).showErrorSnackBar(label: state.message);
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        if (state is Empty) {
          print("Build page CampDetail: Empty");
          BlocProvider.of<CampsBloc>(context).add(GettingCamp(camp));
          return Center();
        } else if (state is Loading) {
          print("Build page CampDetail: Loading");
          return LoadingIndicator();
        } else if (state is LoadedCamp) {
          print("Build page CampDetail: LoadedCamp");
          return FreizeitDetailsCard(freizeit: state.freizeit);
        } else {
          print("Build page CampDetail: Undefined");
          AlertSnackbar(context).showErrorSnackBar(
              label:
                  "Konnte Details zur Freizeit nicht laden: Unbekannter Fehler");
          Navigator.pop(context);
          return NoResultCard(
            label:
                "Konnte Details zur Freizeit nicht laden: Unbekannter Fehler",
            onRefresh: () async {
              BlocProvider.of<CampsBloc>(context).add(GettingCamp(camp));
            },
          );
        }
      }),
    );
  }
}

class FreizeitDetailsCard extends StatelessWidget {
  final Camp freizeit;
  const FreizeitDetailsCard({required this.freizeit}) : super();

  @override
  Widget build(BuildContext context) {
    return DetailsPage(
      titel: freizeit.name,
      untertitel: freizeit.subtitle,
      text: freizeit.description,
      bilder: freizeit.pictures,
      hyperlinks: List.empty(),
      childWidget: _freizeitChildWidget(freizeit: freizeit),
    );
  }
}

// ignore: camel_case_types
class _freizeitChildWidget extends StatelessWidget {
  final Camp freizeit;
  const _freizeitChildWidget({required this.freizeit}) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        ListTile(
          leading: Icon(
            Icons.today,
            color: Theme.of(context).dividerColor,
            size: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          title: Text(
            "${DateFormat('dd.MM.yyyy').format(freizeit.startDate)} - ${DateFormat('dd.MM.yyyy').format(freizeit.endDate)}",
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
              var event = Event(
                title: freizeit.name,
                description: freizeit.description,
                location:
                    "${freizeit.location.adress}, ${freizeit.location.street}, ${freizeit.location.postalCode}",
                startDate: freizeit.startDate,
                endDate: freizeit.endDate,
              );

              if (await Permission.calendarWriteOnly.isGranted) {
                print("Adding camp to calendar");
                Add2Calendar.addEvent2Cal(event);
              } else {
                print(
                    "Calendar permissions not granted. Requesting permission");
                var status = await Permission.calendarWriteOnly.request();
                if (status == PermissionStatus.granted) {
                  Add2Calendar.addEvent2Cal(event);
                } else {
                  AlertSnackbar(context).showErrorSnackBar(
                      label:
                          "Termine können ohne Berechtigung nicht den Kalender hinzugefügt werden");
                }
              }
            },
          ),
        ),
        freizeit.location.adress != ""
            ? ListTile(
                leading: Icon(
                  MdiIcons.mapMarker,
                  color: Theme.of(context).dividerColor,
                  size: 72 / MediaQuery.of(context).devicePixelRatio,
                ),
                title: Text(
                  "${freizeit.location.adress}\n${freizeit.location.street}\n${freizeit.location.postalCode}",
                  style: TextStyle(
                    fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                  ),
                ),
                trailing: GestureDetector(
                  child: Icon(
                    MdiIcons.navigation,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onTap: () async {
                    await MapsLauncher.launchQuery(
                        "${freizeit.location.adress},${freizeit.location.street}, ${freizeit.location.postalCode}");
                  },
                ),
              )
            : Center(),
        ListTile(
          leading: Icon(
            MdiIcons.cakeVariant,
            color: Theme.of(context).dividerColor,
            size: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          title: Text(
            "${freizeit.ageFrom} - ${freizeit.ageTo}",
            style: TextStyle(
              fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        freizeit.price != 0 || freizeit.price2 != 0
            ? ListTile(
                leading: Icon(
                  MdiIcons.currencyEur,
                  color: Theme.of(context).dividerColor,
                  size: 72 / MediaQuery.of(context).devicePixelRatio,
                ),
                title: Text(
                  freizeit.price != 0
                      ? freizeit.price.toString()
                      : freizeit.price2.toString(),
                  style: TextStyle(
                    fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              )
            : Center(),
        freizeit.catering != ""
            ? ListTile(
                leading: Icon(
                  MdiIcons.silverwareForkKnife,
                  color: Theme.of(context).dividerColor,
                  size: 72 / MediaQuery.of(context).devicePixelRatio,
                ),
                title: Text(
                  freizeit.catering,
                  style: TextStyle(
                    fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              )
            : Center(),
        freizeit.accommodation != ""
            ? ListTile(
                leading: Icon(
                  MdiIcons.home,
                  color: Theme.of(context).dividerColor,
                  size: 72 / MediaQuery.of(context).devicePixelRatio,
                ),
                title: Text(
                  freizeit.accommodation,
                  style: TextStyle(
                    fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              )
            : Center(),
        freizeit.journey != ""
            ? ListTile(
                leading: Icon(
                  MdiIcons.carSide,
                  color: Theme.of(context).dividerColor,
                  size: 72 / MediaQuery.of(context).devicePixelRatio,
                ),
                title: Text(
                  freizeit.journey,
                  style: TextStyle(
                    fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              )
            : Center(),
        ListTile(
          leading: Icon(
            MdiIcons.fileDocumentEditOutline,
            color: Theme.of(context).dividerColor,
            size: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          title: OutlinedButton(
            onPressed: () =>
                UrlQuickLauncher().openHttps(freizeit.registrationLink),
            child: Text(
              "Anmelden \n(Anmeldeschluss:${DateFormat('dd.MM.yyyy').format(freizeit.registrationEnd)})",
              style: TextStyle(
                color: Theme.of(context).dividerColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: 36 / MediaQuery.of(context).devicePixelRatio,
        )
      ],
    );
  }
}
