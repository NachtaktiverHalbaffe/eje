import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/PrefImage.dart';
import 'package:eje/pages/eje/hauptamtlichen/domain/entitys/hauptamtlicher.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/hauptamtliche_bloc.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/widgets/hauptamtliche_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

Widget HauptamtlichePageViewer(
    List<Hauptamtlicher> hauptamtliche, BuildContext context) {
  return Swiper(
    itemBuilder: (BuildContext context, int index) {
      return Container(
        child: KontaktCard(hauptamtliche[index]),
        padding: EdgeInsets.only(top: 15, bottom: 15),
      );
    },
    itemCount: hauptamtliche.length,
    itemHeight: 230,
    itemWidth: 150,
    layout: SwiperLayout.STACK,
    loop: true,
  );
}

class KontaktCard extends StatelessWidget {
  final Hauptamtlicher hauptamtlicher;
  KontaktCard(this.hauptamtlicher);

  @override
  Widget build(BuildContext context) {
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
                    value: sl<HauptamtlicheBloc>(),
                    child: HauptamtlicheDetails(hauptamtlicher),
                  ),
                ),
              ),
              child: CachedImage(url: hauptamtlicher.bild),
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
                    fontSize: 19,
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
                Text(
                  hauptamtlicher.bereich,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
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
}
