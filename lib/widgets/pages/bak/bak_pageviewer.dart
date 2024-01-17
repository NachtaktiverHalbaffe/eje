import 'package:auto_size_text/auto_size_text.dart';
import 'package:eje/models/BAKler.dart';
import 'package:eje/utils/injection_container.dart';
import 'package:eje/widgets/cached_image.dart';
import 'package:eje/widgets/pages/bak/bak_details.dart';
import 'package:eje/widgets/pages/bak/bloc/bak_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

class BAKPageViewer extends StatelessWidget {
  final List<BAKler> bakler;

  const BAKPageViewer({required this.bakler}) : super();

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: KontaktCard(bakler: bakler[index]),
          padding: EdgeInsets.only(top: 15, bottom: 15),
        );
      },
      itemCount: bakler.length,
      itemHeight: 230,
      itemWidth: 150,
      layout: SwiperLayout.STACK,
      loop: true,
      autoplay: false,
      autoplayDisableOnInteraction: true,
      autoplayDelay: 5000,
    );
  }
}

class KontaktCard extends StatelessWidget {
  final BAKler bakler;

  const KontaktCard({required this.bakler}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: diContainer<BakBloc>(),
                    child: BAKDetails(bakler),
                  ),
                ),
              ),
              child: CachedImage(url: bakler.image),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 150,
                ),
                AutoSizeText(
                  bakler.name,
                  maxLines: 1,
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
                AutoSizeText(
                  bakler.function,
                  maxLines: 1,
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
