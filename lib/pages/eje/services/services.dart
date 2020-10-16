import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/eje/services/presentation/widgets/services_pageViewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/entities/Service.dart';
import 'presentation/bloc/services_bloc.dart';

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
      BlocProvider(
        create: (_) => sl<ServicesBloc>(),
        child: BlocConsumer<ServicesBloc, ServicesState>(
          listener: (context, state) {
            if (state is Error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          // ignore: missing_return
          builder: (context, state) {
            if (state is Empty) {
              print("Build page: Services Empty");
              BlocProvider.of<ServicesBloc>(context).add(RefreshServices());
              return LoadingIndicator();
            }
            if (state is Loading) {
              print("Build page: Services Loading");
              return LoadingIndicator();
            } else if (state is LoadedServices) {
              print("Build page: LoadedServices");
              return ServicesPageViewer(
                  state.services, context, isCacheEnabled);
            }
          },
        ),
      ),
    ],
  );
}