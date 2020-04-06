import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/hauptamtliche_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

Widget HauptamtlichePageViewer(
    List<Hauptamtlicher> hauptamtliche, BuildContext context) {
  return Swiper(
    itemBuilder: (BuildContext context, int index) {
      return KontaktCard(hauptamtliche[index], context);
    },
    itemCount: hauptamtliche.length,
    pagination: new SwiperPagination(),
    layout: SwiperLayout.STACK,
    loop: false,
    autoplay: false,
  );
}

Widget KontaktCard(Hauptamtlicher hauptamtlicher, BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: sl<HauptamtlicheBloc>(),
          child: null,
        ),
      ),
    ),
    child: Positioned.fill(
        child: ClipRRect(
      borderRadius: new BorderRadius.all(Radius.circular(12)),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(
            width: 400,
            height: 600,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: ExactAssetImage(hauptamtlicher.bild),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                hauptamtlicher.name,
                style: TextStyle(
                  fontSize: 21,
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
                style: TextStyle(
                  fontSize: 17,
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
          )
        ],
      ),
    )),
  );
}
