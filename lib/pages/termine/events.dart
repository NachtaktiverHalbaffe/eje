import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/alert_snackbar.dart';
import 'package:eje/core/widgets/loading_indicator.dart';
import 'package:eje/core/widgets/no_result_card.dart';
import 'package:eje/pages/termine/presentation/bloc/events_bloc.dart';
import 'package:eje/pages/termine/presentation/bloc/events_event.dart';
import 'package:eje/pages/termine/presentation/bloc/events_state.dart';
import 'package:eje/pages/termine/presentation/widgets/event_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

import 'domain/entities/Event.dart';

class Events extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TermineBloc>(),
      child: BlocConsumer<TermineBloc, EventsState>(
        listener: (context, state) {
          if (state is Error) {
            print("Build Page: Error");
            AlertSnackbar(context).showErrorSnackBar(label: state.message);
          }
        },
        // ignore: missing_return
        builder: (context, state) {
          if (state is Empty) {
            BlocProvider.of<TermineBloc>(context).add(RefreshEvents());
            return Center();
          } else if (state is Loading) {
            return LoadingIndicator();
          } else if (state is LoadedEvents) {
            return TermineListView(state.events.reversed.toList());
          } else if (state is Error) {
            return NoResultCard(
              label: "Fehler beim Laden der Events",
              isError: true,
              onRefresh: () async {
                BlocProvider.of<TermineBloc>(context).add(RefreshEvents());
              },
            );
          }
        },
      ),
    );
  }
}

class TermineListView extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final List<Event> termine;
  TermineListView(this.termine);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Theme.of(context).colorScheme.secondary,
              onRefresh: () async {
                BlocProvider.of<TermineBloc>(context).add(RefreshEvents());
              },
              child: SingleChildScrollView(
                physics: ScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 45),
                  child: termine.isNotEmpty
                      ? Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            return EventCard(termine[index]);
                          },
                          itemCount: termine.length,
                          itemHeight: 550,
                          itemWidth: 300,
                          layout: SwiperLayout.STACK,
                          loop: true,
                        )
                      : NoResultCard(
                          label: "Keine Events gefunden",
                          isError: false,
                          onRefresh: () async {
                            BlocProvider.of<TermineBloc>(context)
                                .add(RefreshEvents());
                          },
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
