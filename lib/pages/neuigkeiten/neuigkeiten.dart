import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/widgets/neuigkeitenCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Neuigkeiten extends StatelessWidget {
  final bool isCacheEnabled;

  Neuigkeiten(this.isCacheEnabled);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NeuigkeitenBlocBloc>(),
      child: BlocConsumer<NeuigkeitenBlocBloc, NeuigkeitenBlocState>(
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
        builder: (context, state) {
          if (state is Empty) {
            print("Build Page: Empty");
            BlocProvider.of<NeuigkeitenBlocBloc>(context)
                .add(RefreshNeuigkeiten());
            return Center();
          } else if (state is Loading) {
            print("Build Page Neuigkeiten: Loading");
            return LoadingIndicator();
          } else if (state is Loaded) {
            print("Build Page: Loaded");
            return NeuigkeitenListView(state.neuigkeit,isCacheEnabled);
          } else
            return LoadingIndicator();
        },
      ),
    );
  }
}

class NeuigkeitenListView extends StatelessWidget {
  final List<Neuigkeit> _neuigkeiten;
  final bool isCacheEnabled;


  NeuigkeitenListView(this._neuigkeiten, this.isCacheEnabled);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
          child: _buildNeuigkeitenList(context, _neuigkeiten,isCacheEnabled),
        ),
        SizedBox(
          height: 12,
        )
      ],
    );
  }
}

Widget _buildNeuigkeitenList(BuildContext context, _neuigkeiten, bool isCacheEnabled) {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  return RefreshIndicator(
    key: _refreshIndicatorKey,
    onRefresh: () async{
      await BlocProvider.of<NeuigkeitenBlocBloc>(context).add(RefreshNeuigkeiten());
    },
    child: ListView.builder(
      physics: ScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: _neuigkeiten.length,
      itemBuilder: (context, index) {
        final neuigkeit = _neuigkeiten[index];
        return NeuigkeitenCard(neuigkeit, index,isCacheEnabled);
      },
    ),
  );
}
