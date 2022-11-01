import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/cached_image.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/eje/services/presentation/bloc/services_bloc.dart';
import 'package:eje/pages/eje/services/presentation/widgets/services_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

class ServicesPageViewer extends StatelessWidget {
  final List<Service> services;

  const ServicesPageViewer({required this.services}) : super();

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (context, int index) {
        return Container(
          child: ServicesCard(service: services[index]),
          padding: EdgeInsets.only(top: 15, bottom: 15),
        );
      },
      itemCount: services.length,
      itemHeight: 230,
      itemWidth: 200,
      layout: SwiperLayout.STACK,
      loop: true,
    );
  }
}

class ServicesCard extends StatelessWidget {
  final Service service;
  const ServicesCard({required this.service}) : super();

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
                    value: sl<ServicesBloc>(),
                    child: ServiceDetails(service),
                  ),
                ),
              ),
              child: CachedImage(url: service.images[0]),
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
                    fontSize: 22,
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
}
