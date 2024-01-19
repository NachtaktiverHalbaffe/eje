import 'package:eje/models/Offered_Service.dart';
import 'package:eje/widgets/alert_snackbar.dart';
import 'package:eje/widgets/details_page.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/no_result_card.dart';
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
            AlertSnackbar(context).showErrorSnackBar(label: state.message);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is LoadedService) {
            print("Build Page ServiceDetails: LoadedService");
            return OfferedServiceDetailsCard(service: state.service);
          } else if (state is Empty) {
            BlocProvider.of<ServicesBloc>(context).add(GettingService(service));
            print("Build Page ServiceDetails: Empty");
            return Center();
          } else if (state is Loading) {
            print("Build Page ServiceDetails: Loading");
            return LoadingIndicator();
          } else {
            print("Build Page ServiceDetails: Undefined");
            AlertSnackbar(context).showErrorSnackBar(
                label:
                    "Konnte Details zur DIenstleistung nicht laden: Unbekannter Fehler");
            Navigator.pop(context);
            return NoResultCard(
              label:
                  "Konnte Details zur DIenstleistung nicht laden: Unbekannter Fehler",
              onRefresh: () async {
                BlocProvider.of<ServicesBloc>(context)
                    .add(GettingService(service));
              },
            );
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
