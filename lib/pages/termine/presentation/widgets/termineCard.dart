import 'package:eje/core/utils/injection_container.dart';
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

  TerminCard(this.termin, this.isCacheEnabled);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: new BorderRadius.all(Radius.circular(18)),
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
                        SizedBox(
                            width:
                                48 / MediaQuery.of(context).devicePixelRatio),
                        Text(
                          termin.veranstaltung,
                          style: TextStyle(
                              fontSize:
                                  84 / MediaQuery.of(context).devicePixelRatio,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor),
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
                        Text(
                          termin.motto,
                          style: TextStyle(
                            fontSize:
                                56 / MediaQuery.of(context).devicePixelRatio,
                            fontWeight: FontWeight.bold,
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
                                44 / MediaQuery.of(context).devicePixelRatio),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    OutlineButton(
                      onPressed: () {},
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
}
