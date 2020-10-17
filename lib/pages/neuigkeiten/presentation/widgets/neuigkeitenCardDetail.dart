import 'package:eje/core/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/core/widgets/PrefImage.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/neuigkeit.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/neuigkeiten_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class neuigkeitenCardDetail extends StatefulWidget {
  String title;
  final bool isCacheEnabled;

  neuigkeitenCardDetail(this.title, this.isCacheEnabled);

  @override
  State<StatefulWidget> createState() =>
      _neuigkeitenCardDetail(title, isCacheEnabled);
}

class _neuigkeitenCardDetail extends State<neuigkeitenCardDetail> {
  String title;

  final bool isCacheEnabled;

  _neuigkeitenCardDetail(this.title, this.isCacheEnabled);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<NeuigkeitenBlocBloc>(context)
        .add(GetNeuigkeitDetails(title));
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
            return card(context, state.article, isCacheEnabled);
          } else if (state is LoadingDetails) {
            return LoadingIndicator();
          } else
            return Center();
        },
      ),
    );
  }
}

Widget card(context, List<Article> _article, isCacheEnabled) {
  // Merge all information from List<Article> to one data-entry
  String content = "";
  List<String> bilder = List();
  List<Hyperlink> hyperlinks = List();
  for (int i = 0; i < _article.length; i++) {
    if (_article[i].bilder[0] != "") {
      bilder.addAll(_article[i].bilder);
    }
    if (_article[i].content != "") {
      content = content + _article[i].content;
    }
    if (_article[i].hyperlinks[0].link != "") {
      hyperlinks.addAll(_article[i].hyperlinks);
    }
  }
  return DetailsPage(
    titel: _article[0].titel,
    untertitel: "",
    text: content,
    bild_url: bilder,
    context: context,
    hyperlinks: hyperlinks.isEmpty
        ? [Hyperlink(link: "", description: "")]
        : hyperlinks,
    isCacheEnabled: isCacheEnabled,
    childWidget: SizedBox(
      height: 36 / MediaQuery.of(context).devicePixelRatio,
    ),
  );
}
