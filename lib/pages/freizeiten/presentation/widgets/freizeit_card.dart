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
    borderRadius: new BorderRadius.all(
        Radius.circular(36 / MediaQuery.of(context).devicePixelRatio)),
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
                height: 825 / MediaQuery.of(context).devicePixelRatio,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: ExactAssetImage(freizeit.bilder[0]),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                      height: 630 / MediaQuery.of(context).devicePixelRatio),
                  Text(
                    freizeit.freizeit,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 92 / MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(
                              6 / MediaQuery.of(context).devicePixelRatio,
                              6 / MediaQuery.of(context).devicePixelRatio),
                          blurRadius:
                              18 / MediaQuery.of(context).devicePixelRatio,
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(
                              6 / MediaQuery.of(context).devicePixelRatio,
                              6 / MediaQuery.of(context).devicePixelRatio),
                          blurRadius:
                              18 / MediaQuery.of(context).devicePixelRatio,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    freizeit.motto,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 50 / MediaQuery.of(context).devicePixelRatio,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(
                            6 / MediaQuery.of(context).devicePixelRatio,
                            6 / MediaQuery.of(context).devicePixelRatio,
                          ),
                          blurRadius:
                              18 / MediaQuery.of(context).devicePixelRatio,
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(
                              6 / MediaQuery.of(context).devicePixelRatio,
                              6 / MediaQuery.of(context).devicePixelRatio),
                          blurRadius:
                              18 / MediaQuery.of(context).devicePixelRatio,
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
                height: 225 / MediaQuery.of(context).devicePixelRatio,
                color: Theme.of(context).cardColor,
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                      height: 36 / MediaQuery.of(context).devicePixelRatio),
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                                width: 36 /
                                    MediaQuery.of(context).devicePixelRatio),
                            Icon(Icons.today),
                            SizedBox(
                                width: 12 /
                                    MediaQuery.of(context).devicePixelRatio),
                            Flexible(
                              child: Text(
                                freizeit.datum,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 40 /
                                      MediaQuery.of(context).devicePixelRatio,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                                width: 180 /
                                    MediaQuery.of(context).devicePixelRatio),
                            Icon(MdiIcons.currencyEur),
                            SizedBox(
                                width: 12 /
                                    MediaQuery.of(context).devicePixelRatio),
                            Flexible(
                              child: Text(
                                freizeit.preis,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 40 /
                                      MediaQuery.of(context).devicePixelRatio,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                      TableRow(children: [
                        SizedBox(
                            height:
                                12 / MediaQuery.of(context).devicePixelRatio),
                        SizedBox(
                            height:
                                12 / MediaQuery.of(context).devicePixelRatio)
                      ]),
                      TableRow(children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                                width: 36 /
                                    MediaQuery.of(context).devicePixelRatio),
                            Icon(MdiIcons.mapMarker),
                            SizedBox(
                                width: 12 /
                                    MediaQuery.of(context).devicePixelRatio),
                            Flexible(
                              child: Text(
                                freizeit.ort.Anschrift,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 40 /
                                      MediaQuery.of(context).devicePixelRatio,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                                width: 180 /
                                    MediaQuery.of(context).devicePixelRatio),
                            Icon(MdiIcons.cakeVariant),
                            SizedBox(
                                width: 12 /
                                    MediaQuery.of(context).devicePixelRatio),
                            Flexible(
                              child: Text(
                                freizeit.alter,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 40 /
                                      MediaQuery.of(context).devicePixelRatio,
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
