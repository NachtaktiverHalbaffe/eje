import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/PrefImage.dart';
import 'package:eje/pages/freizeiten/domain/entities/camp.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/camps_bloc.dart';
import 'package:eje/pages/freizeiten/presentation/widgets/camp_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CampCard extends StatelessWidget {
  final Camp camp;
  const CampCard({Key key, this.camp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
        boxShadow: [
          //background color of box
          BoxShadow(
            color: Colors.black,
            blurRadius: 15.0, // soften the shadow
            spreadRadius: 1.0, //extend the shadow
            offset: Offset(
              2, // Move to right 10  horizontally
              2, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: new BorderRadius.all(Radius.circular(12)),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: sl<CampsBloc>(),
                child: CampDetails(camp),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  CachedImage(
                    url: camp.pictures[0],
                    width: MediaQuery.of(context).size.width,
                    height: 275,
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 210),
                      Text(
                        camp.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 6,
                              color: Colors.black,
                            ),
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 6,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        camp.subtitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(
                                2,
                                2,
                              ),
                              blurRadius: 6,
                              color: Colors.black,
                            ),
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 6,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 75,
                    color: Theme.of(context).cardColor,
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 12),
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 12),
                                Icon(Icons.today),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    camp.datum,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 40 /
                                          MediaQuery.of(context)
                                              .devicePixelRatio,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 60),
                                Icon(MdiIcons.currencyEur),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    camp.price,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 40 /
                                          MediaQuery.of(context)
                                              .devicePixelRatio,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                          TableRow(children: [
                            SizedBox(height: 4),
                            SizedBox(height: 4)
                          ]),
                          TableRow(children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 12),
                                Icon(MdiIcons.mapMarker),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    camp.location.Anschrift,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 40 /
                                          MediaQuery.of(context)
                                              .devicePixelRatio,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 60),
                                Icon(MdiIcons.cakeVariant),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    camp.age,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 40 /
                                          MediaQuery.of(context)
                                              .devicePixelRatio,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ])
                        ],
                      )
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
}
