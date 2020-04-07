import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

Widget ArbeitsbereichePageViewer(List<Arbeitsbereich> arbeitsbereiche,
    BuildContext context) {
  return Swiper(
    itemBuilder: (BuildContext context, int index) {
      return KontaktCard(arbeitsbereiche[index], context);
    },
    itemCount: arbeitsbereiche.length,
    itemHeight: 200,
    itemWidth: 200,
    layout: SwiperLayout.STACK,
    loop: true,

  );
}

Widget KontaktCard(Arbeitsbereich arbeitsbereich, BuildContext context) {
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
                          value: sl<ArbeitsbereicheBloc>(),
                          child: null,
                        ),
                  ),
                ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: ExactAssetImage(arbeitsbereich.bilder[0]),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 165,
              ),
              Text(
                arbeitsbereich.arbeitsfeld,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
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
            ],
          ),
        ],
      ),
    ),
  );
}