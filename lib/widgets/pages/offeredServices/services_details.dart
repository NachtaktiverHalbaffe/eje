import 'package:eje/models/Offered_Service.dart';
import 'package:eje/widgets/details_page.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/pages/offeredServices/bloc/services_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfferedServiceDetails extends StatelessWidget {
  final OfferedService service;
  OfferedServiceDetails(this.service);

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
            return OfferedServiceDetailsCard(service: state.service);
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

class OfferedServiceDetailsCard extends StatelessWidget {
  final OfferedService service;

  const OfferedServiceDetailsCard({required this.service}) : super();

  @override
  Widget build(BuildContext context) {
    return DetailsPage(
      titel: service.service,
      text: service.description,
      bilder: service.images,
      untertitel: "",
      hyperlinks: service.hyperlinks.sublist(1),
      childWidget:
          SizedBox(height: 36 / MediaQuery.of(context).devicePixelRatio),
    );
  }
}