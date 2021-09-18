import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_event.dart';
import 'package:eje/pages/termine/presentation/bloc/termine_state.dart';
import 'package:eje/pages/termine/presentation/widgets/termineCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

import 'domain/entities/Termin.dart';

class Termine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TermineBloc>(),
      child: BlocConsumer<TermineBloc, TermineState>(
        listener: (context, state) {
          if (state is Error) {
            print("Build Page: Error");
            ScaffoldMessenger.of(context).showSnackBar(
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
            return TermineListView(state.termine.reversed.toList());
          }
        },
      ),
    );
  }
}

class TermineListView extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final List<Termin> termine;
  TermineListView(this.termine);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: <Widget>[
          new Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Theme.of(context).colorScheme.secondary,
              onRefresh: () async {
                BlocProvider.of<TermineBloc>(context).add(RefreshTermine());
              },
              child: SingleChildScrollView(
                physics: ScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 45),
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return TerminCard(termine[index]);
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
      ),
    );
  }
}
