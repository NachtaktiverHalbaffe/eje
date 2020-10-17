import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/eje/bak/domain/entitys/BAKler.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_bloc.dart';
import 'package:eje/pages/eje/bak/presentation/widgets/bakDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

Widget BAKPageViewer(
    List<BAKler> bakler, BuildContext context, bool isCacheEnabled) {
  return Swiper(
    itemBuilder: (BuildContext context, int index) {
      return KontaktCard(bakler[index], context, isCacheEnabled);
    },
    itemCount: bakler.length,
    itemHeight: 600 / MediaQuery.of(context).devicePixelRatio,
    itemWidth: 450 / MediaQuery.of(context).devicePixelRatio,
    layout: SwiperLayout.STACK,
    loop: true,
  );
}

Widget KontaktCard(BAKler bakler, BuildContext context, bool isCacheEnabled) {
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
                  value: sl<BakBloc>(),
                  child: BAKDetails(isCacheEnabled, bakler),
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: ExactAssetImage(bakler.bild),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 460 / MediaQuery.of(context).devicePixelRatio,
              ),
              Text(
                bakler.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 62 / MediaQuery.of(context).devicePixelRatio,
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
              Text(
                bakler.amt,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 46 / MediaQuery.of(context).devicePixelRatio,
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
