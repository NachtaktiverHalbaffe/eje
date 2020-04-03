import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/neuigkeiten_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

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
    BlocProvider.of<NeuigkeitenBlocBloc>(context)
        .add(GetNeuigkeitDetails(_neuigkeit.titel));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<NeuigkeitenBlocBloc, NeuigkeitenBlocState>(
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
          } else if (state is LoadingDetails) {
            return LoadingIndicator();
          } else
            return Center();
        },
      ),
    );
  }
}

Widget card(context, TAG_BILD, TAG_TITEL, _neuigkeit) {
  final _currentPageNotifier = ValueNotifier<int>(0);
  return ListView(
    physics: ScrollPhysics(
      parent: BouncingScrollPhysics(),
    ),
    children: <Widget>[
      Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: PageView.builder(
                  physics: ScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  onPageChanged: (int index) {
                    _currentPageNotifier.value = index;
                  },
                  pageSnapping: true,
                  controller: PageController(initialPage: 0),
                  itemCount: _neuigkeit.bilder.length,
                  itemBuilder: (context, position) {
                    final bild = _neuigkeit.bilder[position];
                    return Hero(
                      tag: TAG_BILD,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: ExactAssetImage(bild),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // ignore: missing_return
              Container(child: () {
                if (_neuigkeit.bilder.length != 1) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    child: CirclePageIndicator(
                      size: 5,
                      selectedSize: 7.5,
                      dotColor: Colors.white,
                      selectedDotColor: Theme.of(context).accentColor,
                      itemCount: _neuigkeit.bilder.length,
                      currentPageNotifier: _currentPageNotifier,
                    ),
                  );
                }
              }()),
              Positioned(
                left: 16.0,
                top: 16.0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: IconShadowWidget(
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                    showShadow: true,
                    shadowColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Hero(
            tag: TAG_TITEL,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 12, right: 12, top: 16),
              child: Text(
                _neuigkeit.titel,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 16),
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
