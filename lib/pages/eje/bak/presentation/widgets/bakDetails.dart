import 'package:eje/core/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_bloc.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_event.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BAKDetails extends StatefulWidget {
  final bool isCacheEnabled;
  final BAKler bakler;

  BAKDetails(this.isCacheEnabled, this.bakler);

  @override
  _BAKDetailsState createState() => _BAKDetailsState(isCacheEnabled, bakler);
}

class _BAKDetailsState extends State<BAKDetails> {
  final bool isCacheEnabled;
  final BAKler bakler;

  _BAKDetailsState(this.isCacheEnabled, this.bakler);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<BakBloc, BakState>(listener: (context, state) {
        if (state is Error) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
          // ignore: missing_return
          builder: (context, state) {
        if (state is Loading) {
          return LoadingIndicator();
        } else if (state is LoadedBAKler) {
          return HauptamtlicheDetailsCard(
              state.bakler, widget.isCacheEnabled, context);
        }
      }),
    );
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<BakBloc>(context).add(GettingBAKler(bakler.name));
  }
}

Widget HauptamtlicheDetailsCard(
    BAKler bakler, bool isCacheEnabled, BuildContext context) {
  List<String> bilder = List();
  bilder.add(bakler.bild);
  return DetailsPage(
      titel: bakler.name,
      untertitel: bakler.amt,
      text: bakler.vorstellung,
      bild_url: bilder,
      hyperlinks: [Hyperlink(link: "", description: "")],
      pixtureHeight: 1200,
      childWidget: _childBak(bakler, context));
}

Widget _childBak(BAKler bakler, BuildContext context) {
  return Column(
    children: [
      Divider(),
      ListTile(
        leading: Image(
          image: ExactAssetImage("assets/images/icons8_threema_48.png"),
          width: 72 / MediaQuery.of(context).devicePixelRatio,
          height: 72 / MediaQuery.of(context).devicePixelRatio,
          color: Theme.of(context).dividerColor,
        ),
        title: Text(
          bakler.threema,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
      ),
      ListTile(
        leading: Icon(
          MdiIcons.email,
        ),
        title: Text(
          bakler.email,
          style:
              TextStyle(fontSize: 42 / MediaQuery.of(context).devicePixelRatio),
        ),
        trailing: GestureDetector(
          child: Icon(MdiIcons.emailEdit),
          onTap: () async {
            if (await canLaunch("mailto:" + bakler.email)) {
              await launch("mailto:" + bakler.email);
            } else {
              throw 'Could not open Email';
            }
          },
        ),
      ),
      SizedBox(
        height: 36 / MediaQuery.of(context).devicePixelRatio,
      )
    ],
  );
}
