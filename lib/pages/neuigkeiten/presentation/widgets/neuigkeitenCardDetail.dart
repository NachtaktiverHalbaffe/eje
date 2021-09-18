import 'package:eje/pages/articles/presentation/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/neuigkeiten_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NeuigkeitenCardDetail extends StatefulWidget {
  final String title;
  NeuigkeitenCardDetail(this.title);

  @override
  State<StatefulWidget> createState() => _neuigkeitenCardDetail(title);
}

// ignore: camel_case_types
class _neuigkeitenCardDetail extends State<NeuigkeitenCardDetail> {
  String title;
  _neuigkeitenCardDetail(this.title);

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadedDetail) {
            print("Build Page: LoadedDetail");
            return NewsCard(article: state.article);
          } else if (state is LoadingDetails) {
            return LoadingIndicator();
          } else
            return Center();
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final Article article;
  const NewsCard({Key key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Merge all information from List<Article> to one data-entry
    return DetailsPage(
      titel: article.titel,
      untertitel: "",
      text: article.content,
      bilder: article.bilder,
      hyperlinks: article.hyperlinks.isEmpty
          ? [Hyperlink(link: "", description: "")]
          : article.hyperlinks,
      childWidget: SizedBox(
        height: 36 / MediaQuery.of(context).devicePixelRatio,
      ),
    );
  }
}
