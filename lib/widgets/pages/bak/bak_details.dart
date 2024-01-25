import 'package:eje/models/BAKler.dart';
import 'package:eje/utils/url_quick_launcher.dart';
import 'package:eje/widgets/alert_snackbar.dart';
import 'package:eje/widgets/details_page.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/no_result_card.dart';
import 'package:eje/widgets/pages/bak/bloc/bak_bloc.dart';
import 'package:eje/widgets/pages/bak/bloc/bak_event.dart';
import 'package:eje/widgets/pages/bak/bloc/bak_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BAKDetails extends StatelessWidget {
  final BAKler bakler;
  BAKDetails(this.bakler);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<BakBloc, BakState>(listener: (context, state) {
        if (state is Error) {
          AlertSnackbar(context).showErrorSnackBar(label: state.message);
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        if (state is Empty) {
          BlocProvider.of<BakBloc>(context).add(GettingBAKler(bakler.name));
          print("Build page bak: Empty");
          return Center();
        } else if (state is Loading) {
          print("Build page bak: Loading");
          return LoadingIndicator();
        } else if (state is LoadedBAKler) {
          print("Build page bak: LoadedBAKler");
          return HauptamtlicheDetailsCard(bakler: state.bakler);
        } else {
          print("Build page bak: Undefined state");
          AlertSnackbar(context).showErrorSnackBar(
              label:
                  "Konnte Details zum BAK-Mitglied nicht laden: Unbekannter Fehler");
          Navigator.pop(context);
          return NoResultCard(
            label:
                "Konnte Details zum BAK-Mitglied nicht laden: Unbekannter Fehler",
            onRefresh: () async {
              BlocProvider.of<BakBloc>(context).add(GettingBAKler(bakler.name));
            },
          );
        }
      }),
    );
  }
}

class HauptamtlicheDetailsCard extends StatelessWidget {
  final BAKler bakler;

  const HauptamtlicheDetailsCard({required this.bakler}) : super();

  @override
  Widget build(BuildContext context) {
    List<String> bilder = List.empty(growable: true);
    bilder.add(bakler.image);
    return DetailsPage(
        titel: bakler.name,
        untertitel: bakler.function,
        text: bakler.introduction,
        bilder: bilder,
        hyperlinks: List.empty(),
        pictureHeight: 400,
        childWidget: _childBak(bakler, context));
  }
}

Widget _childBak(BAKler bakler, BuildContext context) {
  return Column(
    children: [
      Divider(),
      SizedBox(
        height: 12,
      ),
      bakler.threema != ''
          ? ListTile(
              leading: Image(
                image: ExactAssetImage("assets/images/icons8_threema_48.png"),
                width: 24,
                height: 24,
                color: Theme.of(context).dividerColor,
              ),
              title: Text(
                bakler.threema,
                style: TextStyle(
                    fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                    color: Theme.of(context).dividerColor),
              ),
              trailing: GestureDetector(
                  child: Icon(
                    MdiIcons.messageReplyText,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onTap: () => UrlQuickLauncher()
                      .openHttps("https://threema.id/${bakler.threema}")),
            )
          : SizedBox(
              height: 2,
            ),
      bakler.email != ''
          ? ListTile(
              leading: Icon(
                MdiIcons.email,
                color: Theme.of(context).dividerColor,
              ),
              title: Text(
                bakler.email,
                style: TextStyle(
                  fontSize: 42 / MediaQuery.of(context).devicePixelRatio,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              trailing: GestureDetector(
                  child: Icon(
                    MdiIcons.emailEdit,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onTap: () => UrlQuickLauncher().openMail(bakler.email)),
            )
          : SizedBox(
              height: 2,
            ),
      SizedBox(
        height: 12,
      )
    ],
  );
}
