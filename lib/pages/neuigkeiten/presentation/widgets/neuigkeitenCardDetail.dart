import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/neuigkeiten_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class neuigkeitenCardDetail extends StatefulWidget {
  Neuigkeit _neuigkeit;
  final String TAG_TITEL;
  final String TAG_BILD;

  neuigkeitenCardDetail(this._neuigkeit, this.TAG_BILD, this.TAG_TITEL);

  @override
  State<StatefulWidget> createState() =>
      _neuigkeitenCardDetail(_neuigkeit, TAG_BILD, TAG_TITEL);
}

class _neuigkeitenCardDetail extends State<neuigkeitenCardDetail> {
  Neuigkeit _neuigkeit;
  final String TAG_TITEL;
  final String TAG_BILD;

  _neuigkeitenCardDetail(this._neuigkeit, this.TAG_BILD, this.TAG_TITEL);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<NeuigkeitenBlocBloc>(context).add(GetNeuigkeitDetails(_neuigkeit.titel));
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<NeuigkeitenBlocBloc>(context).add(GetNeuigkeitDetails(_neuigkeit.titel));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Neuigkeiten"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (_) => sl<NeuigkeitenBlocBloc>(),
        child: BlocConsumer<NeuigkeitenBlocBloc, NeuigkeitenBlocState>(
          listener: (context, state) {
            if (state is Error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is LoadedDetail) {
              print("Build Page: LoadedDetail");
              return card(context, TAG_BILD, TAG_TITEL, _neuigkeit);
            } else if (state is Loading) {
              return LoadingIndicator();
            } else
              return LoadingIndicator();
          },
        ),
      ),
    );
  }
}

Widget card(context, TAG_BILD, TAG_TITEL, _neuigkeit) {
  return ListView(
    children: <Widget>[
      Column(
        children: <Widget>[
          Hero(
            tag: TAG_BILD,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              //TODO: Viewpager
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: ExactAssetImage(_neuigkeit.bilder[0].toString()),
              )),
            ),
          ),
          Hero(
            tag: TAG_TITEL,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 10, right: 10, top: 16),
              child: Text(
                _neuigkeit.titel,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 16),
            child: Text(
              _neuigkeit.text,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
