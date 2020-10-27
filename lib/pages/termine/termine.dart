import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_event.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_state.dart';
import 'package:eje/pages/termine/presentation/widgets/termineCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/entities/Termin.dart';

class Termine extends StatelessWidget {
  final bool isCacheEnabled;
  Termine(this.isCacheEnabled);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TermineBloc>(),
      child: BlocConsumer<TermineBloc, TermineState>(
        listener: (context, state) {
          if (state is Error) {
            print("Build Page: Error");
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
            BlocProvider.of<TermineBloc>(context).add(RefreshTermine());
            return Center();
          } else if (state is Loading) {
            return LoadingIndicator();
          } else if (state is LoadedTermine) {
            return TermineListView(
                state.termine.reversed.toList(), context, isCacheEnabled);
          }
        },
      ),
    );
  }
}

Widget TermineListView(
    List<Termin> termine, BuildContext context, bool isCacheEnabled) {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  return new Column(
    children: <Widget>[
      new Expanded(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            await BlocProvider.of<TermineBloc>(context).add(RefreshTermine());
          },
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 45),
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return TerminCard(termine[index], isCacheEnabled);
                },
                itemCount: termine.length,
                itemHeight: 550,
                itemWidth: 300,
                layout: SwiperLayout.STACK,
                loop: true,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
