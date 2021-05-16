import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/PrefImage.dart';
import 'package:eje/pages/articles/articlesPage.dart';
import 'package:eje/pages/articles/presentation/bloc/articles_bloc.dart';
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
      return Container(
        child: KontaktCard(arbeitsbereiche[index], context, isCacheEnabled),
        padding: EdgeInsets.only(top: 15, bottom: 15),
      );
    },
    itemCount: arbeitsbereiche.length,
    itemHeight: 230,
    itemWidth: 200,
    layout: SwiperLayout.STACK,
    loop: true,
  );
}

Widget KontaktCard(
    Arbeitsbereich arbeitsbereich, BuildContext context, bool isCacheEnabled) {
  return Container(
    decoration: new BoxDecoration(
      boxShadow: [
        //background color of box
        BoxShadow(
          color: Colors.black,
          blurRadius: 10.0, // soften the shadow
          spreadRadius: 1.0, //extend the shadow
          offset: Offset(
            1, // Move to right 10  horizontally
            1, // Move to bottom 10 Vertically
          ),
        )
      ],
    ),
    child: ClipRRect(
      borderRadius: new BorderRadius.all(Radius.circular(12)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: sl<ArticlesBloc>(),
                  child: ArticlesPage(
                    url: arbeitsbereich.url,
                    isCacheEnabled: isCacheEnabled,
                  ),
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: PrefImage(arbeitsbereich.bilder[0], isCacheEnabled),
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
                  fontSize: 72 / MediaQuery.of(context).devicePixelRatio,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
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
            ],
          ),
        ],
      ),
    ),
  );
}
