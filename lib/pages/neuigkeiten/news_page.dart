import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/alert_snackbar.dart';
import 'package:eje/core/widgets/loading_indicator.dart';
import 'package:eje/core/widgets/no_result_card.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/news.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/widgets/news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsBloc>(),
      lazy: false,
      child: BlocConsumer<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is Error) {
            print("Build Page: Error");
            AlertSnackbar(context).showErrorSnackBar(label: state.message);
          }
        },
        builder: (context, state) {
          if (state is Empty) {
            print("Build Page Neuigkeiten: Empty");
            BlocProvider.of<NewsBloc>(context).add(RefreshNews());
            return Center();
          } else if (state is Loading) {
            print("Build Page Neuigkeiten: Loading");
            return LoadingIndicator();
          } else if (state is Loaded) {
            print("Build Page Neuigkeiten: Loaded");
            return NeuigkeitenListView(state.neuigkeit.toList());
          } else if (state is Error) {
            return NoResultCard(
              label: "Fehler beim Laden der Neuigkeiten",
              isError: true,
              onRefresh: () async {
                BlocProvider.of<NewsBloc>(context).add(RefreshNews());
              },
            );
          } else {
            return Center();
          }
        },
      ),
    );
  }
}

class NeuigkeitenListView extends StatelessWidget {
  final List<News> _neuigkeiten;

  NeuigkeitenListView(this._neuigkeiten);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _buildNeuigkeitenList(context, _neuigkeiten.reversed.toList()),
        ),
      ],
    );
  }
}

Widget _buildNeuigkeitenList(BuildContext context, neuigkeiten) {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    body: RefreshIndicator(
      color: Theme.of(context).colorScheme.secondary,
      key: refreshIndicatorKey,
      onRefresh: () async {
        BlocProvider.of<NewsBloc>(context).add(RefreshNews());
      },
      child: neuigkeiten.length != 0
          ? ListView.builder(
              physics: ScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              // Padding to avoid cards being cut off
              padding: EdgeInsets.only(
                bottom: 20,
                top: 40,
              ),
              itemCount: neuigkeiten.length,
              itemBuilder: (context, index) {
                final neuigkeit = neuigkeiten[index];
                return NewsCard(neuigkeit);
              },
            )
          : NoResultCard(
              label: "Keine Neuigkeiten gefunden",
              isError: false,
              onRefresh: () async {
                BlocProvider.of<NewsBloc>(context).add(RefreshNews());
              },
            ),
    ),
  );
}
