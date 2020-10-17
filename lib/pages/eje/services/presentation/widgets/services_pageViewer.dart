import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/PrefImage.dart';
import 'package:eje/pages/articles/articlesPage.dart';
import 'package:eje/pages/articles/presentation/bloc/articles_bloc.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/eje/services/presentation/bloc/services_bloc.dart';
import 'package:eje/pages/eje/services/presentation/widgets/servicesDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

Widget ServicesPageViewer(
    List<Service> services, BuildContext context, bool isCacheEnabled) {
  return Swiper(
    itemBuilder: (BuildContext context, int index) {
      return ServicesCard(services[index], context, isCacheEnabled);
    },
    itemCount: services.length,
    itemHeight: 200,
    itemWidth: 200,
    layout: SwiperLayout.STACK,
    loop: true,
  );
}

Widget ServicesCard(
    Service service, BuildContext context, bool isCacheEnabled) {
  return Container(
    child: ClipRRect(
      borderRadius: new BorderRadius.all(Radius.circular(12)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: sl<ArticlesBloc>(),
                    child: ArticlesPage(
                      isCacheEnabled: isCacheEnabled,
                      url: service.hyperlinks[0].link,
                    ),
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: service.bilder[0].contains("http")
                      ? PrefImage(service.bilder[0], isCacheEnabled)
                      : ExactAssetImage(service.bilder[0]),
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
                service.service,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 72 / MediaQuery.of(context).devicePixelRatio,
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
