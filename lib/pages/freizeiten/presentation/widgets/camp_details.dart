import 'package:eje/core/platform/map_launcher.dart';
import 'package:eje/pages/articles/presentation/widgets/details_page.dart';
import 'package:eje/core/widgets/loading_indicator.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CampDetails extends StatelessWidget {
  final Camp camp;
  CampDetails(this.camp);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CampsBloc, CampState>(listener: (context, state) {
        if (state is Error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      }, builder: (context, state) {
        if (state is Empty) {
          print("Build page CampDetail: Empty");
          BlocProvider.of<CampsBloc>(context).add(GettingCamp(camp));
          return LoadingIndicator();
        } else if (state is Loading) {
          print("Build page CampDetail: Loading");
          return LoadingIndicator();
        } else if (state is LoadedCamp) {
          print("Build page CampDetail: LoadedCamp");
          return FreizeitDetailsCard(freizeit: state.freizeit);
        } else {
          print("Build page CampDetail: Undefined");
          BlocProvider.of<CampsBloc>(context).add(GettingCamp(camp));
          return Container();
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
      hyperlinks: [Hyperlink(link: "", description: "")],
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
        ),
        freizeit.price != 0 || freizeit.price != 0
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
                    await MapLauncher.launchQuery(
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
            onPressed: () async {
              if (await canLaunchUrlString(freizeit.registrationLink)) {
                await launchUrlString(freizeit.registrationLink);
              } else {
                throw 'Could not launch $freizeit.registrationLink';
              }
            },
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
