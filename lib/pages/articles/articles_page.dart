import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/alert_snackbar.dart';
import 'package:eje/pages/articles/presentation/widgets/details_page.dart';
import 'package:eje/core/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'domain/entity/Article.dart';
import 'presentation/bloc/articles_bloc.dart';

class ArticlesPage extends StatelessWidget {
  final String url;
  const ArticlesPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ArticlesBloc>(),
      child: BlocConsumer<ArticlesBloc, ArticlesState>(
        listener: (context, state) {
          if (state is Error) {
            print("Build Page: Error");
            AlertSnackbar(context).showErrorSnackBar(label: state.message);
          }
        },
        builder: (context, state) {
          if (state is Empty) {
            print("Build Page Articles: Empty");
            BlocProvider.of<ArticlesBloc>(context).add(GettingArticle(url));
            return LoadingIndicator();
          } else if (state is Loading) {
            print("Build Page Articles: Loading");
            return LoadingIndicator();
          } else if (state is LoadedArticle) {
            print("Build Page Articles: Loaded");
            return ArticlePage(state.article);
          } else if (state is ReloadedArticle) {
            print("Build Page Articles: Reloaded");
            return ArticlePage(state.article);
          } else if (state is FollowedHyperlink) {
            print("Build Page Articles: FollowedHyperlink");
            return ArticlePage(state.article);
          } else {
            print("Build Page Articles: Undefined");
            // BlocProvider.of<ArticlesBloc>(context).add(RefreshArticle(url));
            return LoadingIndicator();
          }
        },
      ),
    );
  }
}

class ArticlePage extends StatelessWidget {
  final Article article;
  ArticlePage(this.article);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        child: DetailsPage(
          titel: article.titel,
          untertitel: "",
          text: article.content,
          bilder: article.bilder,
          hyperlinks: article.hyperlinks,
          childWidget: SizedBox(
            height: 1 / MediaQuery.of(context).devicePixelRatio,
          ),
        ),
        onRefresh: () async {
          BlocProvider.of<ArticlesBloc>(context)
              .add(RefreshArticle(article.url));
        },
      ),
    );
  }
}
