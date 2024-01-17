import 'package:auto_size_text/auto_size_text.dart';
import 'package:eje/models/camp.dart';
import 'package:eje/utils/injection_container.dart';
import 'package:eje/widgets/cached_image.dart';
import 'package:eje/widgets/pages/camps/bloc/camps_bloc.dart';
import 'package:eje/widgets/pages/camps/camp_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CampCard extends StatelessWidget {
  final Camp camp;
  const CampCard({required this.camp}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
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
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: diContainer<CampsBloc>(),
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
                      SizedBox(height: 200),
                      AutoSizeText(
                        camp.name,
                        maxLines: 1,
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
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: AutoSizeText(
                          camp.subtitle,
                          maxLines: 1,
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
                      )
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
                                  child: AutoSizeText(
                                    "${DateFormat('dd.MM.').format(camp.startDate)} - ${DateFormat('dd.MM.yyyy').format(camp.endDate)}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12.5,
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
                                    camp.price != 0
                                        ? "${camp.price} Euro"
                                        : "${camp.price2} Euro",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.5,
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
                                    camp.location.adress,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.5,
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
                                    "${camp.ageFrom} - ${camp.ageTo}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.5,
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
