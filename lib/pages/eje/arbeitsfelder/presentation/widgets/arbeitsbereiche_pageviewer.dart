import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/eje/arbeitsfelder/domain/entities/Arbeitsbereich.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_bloc.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/widgets/arbeitsbereicheDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

Widget ArbeitsbereichePageViewer(List<Arbeitsbereich> arbeitsbereiche,
    BuildContext context, bool isCacheEnabled) {
  return Swiper(
    itemBuilder: (BuildContext context, int index) {
      return KontaktCard(arbeitsbereiche[index], context, isCacheEnabled);
    },
    itemCount: arbeitsbereiche.length,
    itemHeight: 600 / MediaQuery.of(context).devicePixelRatio,
    itemWidth: 600 / MediaQuery.of(context).devicePixelRatio,
    layout: SwiperLayout.STACK,
    loop: true,
  );
}

Widget KontaktCard(
    Arbeitsbereich arbeitsbereich, BuildContext context, bool isCacheEnabled) {
  return Container(
    child: ClipRRect(
      borderRadius: new BorderRadius.all(
          Radius.circular(36 / MediaQuery.of(context).devicePixelRatio)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: sl<ArbeitsbereicheBloc>(),
                  child: ArbeitsbereicheDetails(isCacheEnabled, arbeitsbereich),
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
                height: 495 / MediaQuery.of(context).devicePixelRatio,
              ),
              Text(
                arbeitsbereich.arbeitsfeld,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 72 / MediaQuery.of(context).devicePixelRatio,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(
                          6 / MediaQuery.of(context).devicePixelRatio,
                          6 / MediaQuery.of(context).devicePixelRatio),
                      blurRadius: 18 / MediaQuery.of(context).devicePixelRatio,
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(
                          6 / MediaQuery.of(context).devicePixelRatio,
                          6 / MediaQuery.of(context).devicePixelRatio),
                      blurRadius: 18 / MediaQuery.of(context).devicePixelRatio,
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
