import 'package:eje/core/widgets/alert_snackbar.dart';
import 'package:eje/core/widgets/loading_indicator.dart';
import 'package:eje/pages/eje/services/presentation/widgets/services_pageViewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/services_bloc.dart';

class Services extends StatelessWidget {
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
              return LoadingIndicator();
            }
            if (state is Loading) {
              print("Build page: Services Loading");
              return LoadingIndicator();
            } else if (state is LoadedServices) {
              print("Build page: LoadedServices");
              return ServicesPageViewer(services: state.services);
            } else if (state is Error) {
              return Center();
            } else {
              return Center();
            }
          },
        ),
      ],
    );
  }
}
