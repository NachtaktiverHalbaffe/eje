import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_bloc.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_event.dart';
import 'package:eje/pages/eje/bak/presentation/bloc/bak_state.dart';
import 'package:eje/pages/eje/bak/presentation/widgets/bak_pageviewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget BAK(BuildContext context) {
  return Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          SizedBox(
            width: 24,
          ),
          Text(
            "Vorstand \& BAK",
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
              return BAKPageViewer(state.bak, context);
            }
          },
        ),
      ),
      SizedBox(
        height: 12,
      ),
    ],
  );
}
