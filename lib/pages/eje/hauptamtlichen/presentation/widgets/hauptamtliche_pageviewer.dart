import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/hauptamtliche_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

Widget HauptamtlichePageViewer(List<Hauptamtlicher> hauptamtliche,
    BuildContext context) {
  return Swiper(
    itemBuilder: (BuildContext context, int index) {
      return KontaktCard(hauptamtliche[index], context);
    },
    itemCount: hauptamtliche.length,
    itemHeight: 200,
    itemWidth: 150,
    layout: SwiperLayout.STACK,
    loop: true,

  );
}

Widget KontaktCard(Hauptamtlicher hauptamtlicher, BuildContext context) {
  return Container(
    child: ClipRRect(
      borderRadius: new BorderRadius.all(Radius.circular(12)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          GestureDetector(
            onTap: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        BlocProvider.value(
                          value: sl<HauptamtlicheBloc>(),
                          child: null,
                        ),
                  ),
                ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: ExactAssetImage(hauptamtlicher.bild),
                ),
              ),
            ),
          ),
          Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 160,
                  ),
                  Text(
                    hauptamtlicher.name,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                    hauptamtlicher.bereich,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
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
    ),
  );
}
