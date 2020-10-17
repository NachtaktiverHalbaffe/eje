import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/DetailsPage.dart';
import 'package:eje/core/widgets/LoadingIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/entity/Article.dart';
import 'domain/usecases/getArticle.dart';
import 'presentation/bloc/articles_bloc.dart';

class ArticlesPage extends StatefulWidget {
  final bool isCacheEnabled;
  final String url;

  const ArticlesPage({this.isCacheEnabled, this.url});

  @override
  State<StatefulWidget> createState() =>
      _articleBloc(isCacheEnabled: isCacheEnabled, url: url);
}

class _articleBloc extends State<ArticlesPage> {
  final bool isCacheEnabled;
  final String url;

  _articleBloc({this.isCacheEnabled, this.url});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<ArticlesBloc>(context).add(RefreshArticle(url));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ArticlesBloc>(),
      child: BlocConsumer<ArticlesBloc, ArticlesState>(
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
            print("Build Page Articles: Empty");
            BlocProvider.of<ArticlesBloc>(context).add(GettingArticle(url));
            return Center();
          } else if (state is Loading) {
            print("Build Page Articles: Loading");
            return LoadingIndicator();
          } else if (state is LoadedArticle) {
            print("Build Page Articles: Loaded");
            return _articlePage(state.article, isCacheEnabled, context);
          } else if (state is ReloadedArticle) {
            print("Build Page Articles: Loaded");
            return _articlePage(state.article, isCacheEnabled, context);
          } else
            return LoadingIndicator();
        },
      ),
    );
  }
}

Widget _articlePage(
    Article article, bool isCacheEnabled, BuildContext context) {
  return RefreshIndicator(
      child: DetailsPage(
        titel: article.titel,
        untertitel: "",
        text: article.content,
        bild_url: article.bilder,
        hyperlinks: article.hyperlinks,
        isCacheEnabled: isCacheEnabled,
        context: context,
        childWidget: SizedBox(
          height: 1 / MediaQuery.of(context).devicePixelRatio,
        ),
      ),
      onRefresh: () async {
        await BlocProvider.of<ArticlesBloc>(context)
            .add(RefreshArticle(article.url));
      });
}
