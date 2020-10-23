import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_bloc.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_event.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/bloc/arbeitsbereiche_state.dart';
import 'package:eje/pages/eje/arbeitsfelder/presentation/widgets/arbeitsbereiche_pageviewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget Arbeitsbereiche(BuildContext context, bool isCacheEnabled) {
  return Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          SizedBox(
            width: 24,
          ),
          Text(
            "Arbeitsfelder",
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
      BlocProvider(
        create: (_) => sl<ArbeitsbereicheBloc>(),
        child: BlocConsumer<ArbeitsbereicheBloc, ArbeitsbereicheState>(
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
              print("Build page: Arbeitsbereiche Empty");
              BlocProvider.of<ArbeitsbereicheBloc>(context)
                  .add(RefreshArbeitsbereiche());
              return LoadingIndicator();
            }
            if (state is Loading) {
              print("Build page: Arbeitsbereiche Loading");
              return LoadingIndicator();
            } else if (state is LoadedArbeitsbereiche) {
              print("Build page: LoadedArbeitsbereiche");
              return ArbeitsbereichePageViewer(
                  state.arbeitsbereiche, context, isCacheEnabled);
            }
          },
        ),
      ),
    ],
  );
}
