import 'package:eje/widgets/alert_snackbar.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/no_result_card.dart';
import 'package:eje/widgets/pages/offeredServices/bloc/services_bloc.dart';
import 'package:eje/widgets/pages/offeredServices/services_pageViewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfferedServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                fontSize: 84 / MediaQuery.of(context).devicePixelRatio,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        BlocConsumer<ServicesBloc, ServicesState>(
          listener: (context, state) {
            if (state is Error) {
              AlertSnackbar(context).showErrorSnackBar(label: state.message);
            }
          },
          builder: (context, state) {
            if (state is Empty) {
              print("Build page: Services Empty");
              BlocProvider.of<ServicesBloc>(context).add(RefreshServices());
              return Center();
            }
            if (state is Loading) {
              print("Build page: Services Loading");
              return LoadingIndicator();
            } else if (state is LoadedServices) {
              print("Build page: LoadedServices");
              return state.services.isNotEmpty
                  ? OfferedServicesPageViewer(services: state.services)
                  : NoResultCard(
                      label: "Fehler beim Laden der Hauptamtliche",
                      scale: 0.4,
                      onRefresh: () async {
                        BlocProvider.of<ServicesBloc>(context)
                            .add(RefreshServices());
                      });
            } else if (state is Error) {
              return NoResultCard(
                  label: state.message,
                  scale: 0.4,
                  onRefresh: () async {
                    BlocProvider.of<ServicesBloc>(context)
                        .add(RefreshServices());
                  });
            } else {
              return NoResultCard(
                  label: "Fehler beim Laden der Dienstleistungen",
                  scale: 0.4,
                  onRefresh: () async {
                    BlocProvider.of<ServicesBloc>(context)
                        .add(RefreshServices());
                  });
            }
          },
        ),
      ],
    );
  }
}
