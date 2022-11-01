import 'package:eje/pages/articles/presentation/widgets/details_page.dart';
import 'package:eje/core/widgets/loading_indicator.dart';
import 'package:eje/pages/eje/services/domain/entities/Service.dart';
import 'package:eje/pages/eje/services/presentation/bloc/services_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceDetails extends StatelessWidget {
  final Service service;
  ServiceDetails(this.service);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadedService) {
            print("Build Page ServiceDetails: LoadedService");
            return ServiceDetailsCard(service: state.service);
          } else if (state is Empty) {
            BlocProvider.of<ServicesBloc>(context).add(GettingService(service));
            print("Build Page ServiceDetails: Empty");
            return LoadingIndicator();
          } else if (state is Loading) {
            print("Build Page ServiceDetails: Loading");
            return LoadingIndicator();
          } else {
            print("Build Page ServiceDetails: Undefined");
            BlocProvider.of<ServicesBloc>(context).add(GettingService(service));
            return LoadingIndicator();
          }
        },
      ),
    );
  }
}

class ServiceDetailsCard extends StatelessWidget {
  final Service service;

  const ServiceDetailsCard({required this.service}) : super();

  @override
  Widget build(BuildContext context) {
    return DetailsPage(
      titel: service.service,
      text: service.description,
      bilder: service.images,
      untertitel: "",
      hyperlinks: service.service != "Verleih"
          ? service.hyperlinks.sublist(1)
          : service.hyperlinks.sublist(0, 1),
      childWidget:
          SizedBox(height: 36 / MediaQuery.of(context).devicePixelRatio),
    );
  }
}
