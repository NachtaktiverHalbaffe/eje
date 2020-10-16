import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_bloc.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_event.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_state.dart';
import 'package:eje/pages/eje/bak/presentation/widgets/bak_pageviewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget BAK(BuildContext context, bool isCacheEnabled) {
  return Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          SizedBox(
            width: 72 / MediaQuery.of(context).devicePixelRatio,
          ),
          Text(
            "Vorstand \& BAK",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 84 / MediaQuery.of(context).devicePixelRatio,
            ),
          ),
        ],
      ),
      SizedBox(
        height: 36 / MediaQuery.of(context).devicePixelRatio,
      ),
      BlocProvider(
        create: (_) => sl<BakBloc>(),
        child: BlocConsumer<BakBloc, BakState>(
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
              print("Build page: BAK Empty");
              BlocProvider.of<BakBloc>(context).add(RefreshBAK());
              return LoadingIndicator();
            }
            if (state is Loading) {
              print("Build page: Bak Loading");
              return LoadingIndicator();
            } else if (state is LoadedBAK) {
              print("Build page: LoadedBak");
              return BAKPageViewer(state.bak, context, isCacheEnabled);
            }
          },
        ),
      ),
      SizedBox(
        height: 36 / MediaQuery.of(context).devicePixelRatio,
      ),
    ],
  );
}
