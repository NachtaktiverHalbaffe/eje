import 'package:eje/pages/articles/presentation/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_bloc.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_event.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BAKDetails extends StatelessWidget {
  final BAKler bakler;
  BAKDetails(this.bakler);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<BakBloc, BakState>(listener: (context, state) {
        if (state is Error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      }, builder: (context, state) {
        if (state is Empty) {
          BlocProvider.of<BakBloc>(context).add(GettingBAKler(bakler.name));
          print("Build page bak: Empty");
          return LoadingIndicator();
        } else if (state is Loading) {
          print("Build page bak: Loading");
          return LoadingIndicator();
        } else if (state is LoadedBAKler) {
          print("Build page bak: LoadedBAKler");
          return HauptamtlicheDetailsCard(bakler: state.bakler);
        } else {
          print("Build page bak: Undefined state");
          BlocProvider.of<BakBloc>(context).add(GettingBAKler(bakler.name));
          return Container();
        }
      }),
    );
  }
}

class HauptamtlicheDetailsCard extends StatelessWidget {
  final BAKler bakler;

  const HauptamtlicheDetailsCard({Key key, this.bakler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> bilder = List.empty(growable: true);
    bilder.add(bakler.bild);
    return DetailsPage(
        titel: bakler.name,
        untertitel: bakler.amt,
        text: bakler.vorstellung,
        bilder: bilder,
        hyperlinks: [Hyperlink(link: "", description: "")],
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
                onTap: () async {
                  if (await canLaunch("https://threema.id/" + bakler.threema)) {
                    await launch("https://threema.id/" + bakler.threema);
                  } else {
                    throw 'Could not open Threema';
                  }
                },
              ),
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
                onTap: () async {
                  if (await canLaunch("mailto:" + bakler.email)) {
                    await launch("mailto:" + bakler.email);
                  } else {
                    throw 'Could not open Email';
                  }
                },
              ),
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
