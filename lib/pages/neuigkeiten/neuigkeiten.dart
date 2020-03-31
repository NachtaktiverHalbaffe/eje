import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/widgets/neuigkeitenCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:eje/core/utils/injection_container.dart';

class Neuigkeiten extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        builder: (_) => sl<NeuigkeitenBlocBloc>(),
        child: BlocListener<NeuigkeitenBlocBloc, NeuigkeitenBlocState>(
          listener: (context, state) {
            if (state is Error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<NeuigkeitenBlocBloc, NeuigkeitenBlocState>(
            builder: (context, state) {
              if (state is Empty) {
                return Center();
              } else if (state is Loading) {
                return LoadingIndicator();
              } else if (state is Loaded) {
                return NeuigkeitenListView();
              } else
                return Scaffold();
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // DB komprimieren
    Hive.box('Neuigkeiten').compact();
    // Offline Database für Cached Artikel schließen
    Hive.box('Neuigkeiten').close();
  }
}

class NeuigkeitenListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: _buildNeuigkeitenList(context),
          ),
        ],
      ),
    );
  }
}

Widget _buildNeuigkeitenList(BuildContext context) {
  final neuigkeitenBox = Hive.box('Neuigkeiten');

 return ListView.builder(
        itemCount: neuigkeitenBox.length,
        itemBuilder: (context, index) {
          final neuigkeit = neuigkeitenBox.getAt(index) as Neuigkeit;
          return NeuigkeitenCard(neuigkeit, index);
        },
      );
}
