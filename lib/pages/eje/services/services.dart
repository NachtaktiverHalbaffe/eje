import 'package:eje/pages/eje/services/presentation/widgets/services_pageViewer.dart';
import 'package:flutter/material.dart';

import 'domain/entities/Service.dart';

Widget Services(BuildContext context, bool isCacheEnabled) {
  List<Service> services;
  return Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          SizedBox(
            width: 24,
          ),
          Text(
            "Services",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ],
      ),
      SizedBox(
        height: 12,
      ),
      ServicesPageViewer(services, context, isCacheEnabled),
      SizedBox(
        height: 12,
      ),
    ],
  );
}
