import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/freizeiten_bloc.dart';
import 'package:eje/pages/freizeiten/presentation/widgets/freizeitDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Widget FreizeitCard(
    Freizeit freizeit, BuildContext context, bool isCacheEnabled) {
  final _currentPageNotifier = ValueNotifier<int>(0);

  return ClipRRect(
    borderRadius: new BorderRadius.all(Radius.circular(12)),
    child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: sl<FreizeitenBloc>(),
            child: FreizeitDetails(freizeit, isCacheEnabled),
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
              Container(
                width: MediaQuery.of(context).size.width,
                height: 275,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: ExactAssetImage(freizeit.bilder[0]),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 210),
                  Text(
                    freizeit.freizeit,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 92/MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    freizeit.motto,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 50/MediaQuery.of(context).devicePixelRatio,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
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
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                                freizeit.datum,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 40/MediaQuery.of(context).devicePixelRatio,
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
                                freizeit.preis,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 40/MediaQuery.of(context).devicePixelRatio,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                      TableRow(
                          children: [SizedBox(height: 4), SizedBox(height: 4)]),
                      TableRow(children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 12),
                            Icon(MdiIcons.mapMarker),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                freizeit.ort.Anschrift,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 40/MediaQuery.of(context).devicePixelRatio,
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
                                freizeit.alter,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 40/MediaQuery.of(context).devicePixelRatio,
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
  );
}
