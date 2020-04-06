import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/bloc.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/hauptamtliche_bloc.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/bloc/hauptamtliche_state.dart';
import 'package:eje/pages/eje/hauptamtlichen/presentation/widgets/hauptamtliche_pageviewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget Hauptamtliche(BuildContext context) {
  return Column(
    children: <Widget>[
      Text(
        "Hauptamtliche Mitarbeiter",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21,
        ),
      ),
      BlocProvider(
        create: (_) => sl<HauptamtlicheBloc>(),
        child: BlocConsumer<HauptamtlicheBloc, HauptamtlicheState>(
          listener: (context, state) {
            if (state is Error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }else if (state is Empty) {
              BlocProvider.of<HauptamtlicheBloc>(context).add(RefreshHauptamtliche());
            }
          },
          // ignore: missing_return
          builder: (context, state) {
            if(state is Loading){
              return LoadingIndicator();
            } else if(state is LoadedHauptamtliche){
              return HauptamtlichePageViewer(state.hauptamtliche, context);
            }
          },
        ),
      ),
    ],
  );
}
