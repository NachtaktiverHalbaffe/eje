import 'dart:developer';

import 'package:eje/core/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/eje/services/presentation/bloc/services_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceDetails extends StatefulWidget {
  final bool isCacheEnabled;
  final Service service;

  ServiceDetails(this.isCacheEnabled, this.service);

  @override
  _ServiceDetailsState createState() =>
      _ServiceDetailsState(isCacheEnabled, service);
}

class _ServiceDetailsState extends State<ServiceDetails> {
  final bool isCacheEnabled;
  final Service service;

  _ServiceDetailsState(this.isCacheEnabled, this.service);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          BlocConsumer<ServicesBloc, ServicesState>(listener: (context, state) {
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
        if (state is Loading) {
          return LoadingIndicator();
        } else if (state is LoadedService) {
          return ServiceDetailsCard(
              state.service, widget.isCacheEnabled, context);
        }
      }),
    );
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<ServicesBloc>(context).add(GettingService(service));
  }
}

Widget ServiceDetailsCard(
    Service service, bool isCacheEnabled, BuildContext context) {
  return DetailsPage(
    titel: service.service,
    text: service.inhalt,
    bild_url: service.bilder,
    context: context,
    untertitel: "",
    hyperlinks: service.service != "Verleih"
        ? service.hyperlinks.sublist(1)
        : service.hyperlinks.sublist(0, 1),
    childWidget: SizedBox(height: 36 / MediaQuery.of(context).devicePixelRatio),
  );
}
