import 'package:eje/widgets/alert_snackbar.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/pages/bak/bak_pageviewer.dart';
import 'package:eje/widgets/pages/bak/bloc/bak_bloc.dart';
import 'package:eje/widgets/pages/bak/bloc/bak_event.dart';
import 'package:eje/widgets/pages/bak/bloc/bak_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BAK extends StatelessWidget {
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
              "Vorstand & BAK",
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
        BlocConsumer<BakBloc, BakState>(
          listener: (context, state) {
            if (state is Error) {
              AlertSnackbar(context).showErrorSnackBar(label: state.message);
            }
          },
          builder: (context, state) {
            if (state is Empty) {
              print("Build page: BAK Empty");
              BlocProvider.of<BakBloc>(context).add(RefreshBAK());
              return LoadingIndicator();
            }
            if (state is Loading) {
              print("Build page: Bak Loading");
              return LoadingIndicator();
            } else if (state is LoadedBAK) {
              print("Build page: LoadedBak");
              return BAKPageViewer(bakler: state.bak);
            } else if (state is Error) {
              return Center();
            } else {
              return Center();
            }
          },
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
