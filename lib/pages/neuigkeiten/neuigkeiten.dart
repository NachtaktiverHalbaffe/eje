import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/widgets/neuigkeitenCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'package:eje/core/utils/injection_container.dart';

class Neuigkeiten extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NeuigkeitenBlocBloc>(),
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
            return Center(
                child: FlatButton(
              onPressed: () =>
                  sl<NeuigkeitenBlocBloc>()..add(RefreshNeuigkeiten()),
              child: Text("Refresh"),
            ));
          } else if (state is Loading) {
            print("Build Page: Loading");
            return LoadingIndicator();
          } else if (state is Loaded) {
            print("Build Page: Loaded");
            return LoadingIndicator();
          } else
            return LoadingIndicator();
        },
      ),
    );
  }
}

class NeuigkeitenListView extends StatelessWidget {
  final List<Neuigkeit> _neuigkeiten;

  NeuigkeitenListView(this._neuigkeiten);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
          child: _buildNeuigkeitenList(context, _neuigkeiten),
        ),
      ],
    );
  }
}

Widget _buildNeuigkeitenList(BuildContext context, _neuigkeiten) {
  return ListView.builder(
    itemCount: _neuigkeiten.length,
    itemBuilder: (context, index) {
      final neuigkeit = _neuigkeiten.getAt(index) as Neuigkeit;
      return NeuigkeitenCard(neuigkeit, index);
    },
  );
}
