import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/freizeiten/domain/entities/Freizeit.dart';
import 'package:eje/pages/freizeiten/presentation/bloc/freizeiten_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget FreizeitCard(
    Freizeit freizeit, BuildContext context, bool isCacheEnabled) {
  final _currentPageNotifier = ValueNotifier<int>(0);

  return ClipRRect(
    borderRadius: new BorderRadius.all(Radius.circular(12)),
    child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: sl<FreizeitenBloc>(),
            child: null,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 230,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: ExactAssetImage(freizeit.bilder[0]),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 190),
                  Text(
                    freizeit.freizeit,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
          Container(
            width:MediaQuery.of(context).size.width ,
              height: 120,
            color: Theme.of(context).backgroundColor,
          )
        ],
      ),
    ),
  );
}
