import 'package:eje/models/Article.dart';
import 'package:eje/utils/injection_container.dart';
import 'package:eje/widgets/alert_snackbar.dart';
import 'package:eje/widgets/details_page.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/no_result_card.dart';
import 'package:eje/widgets/pages/articles/bloc/articles_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticlesPage extends StatelessWidget {
  final String url;
  const ArticlesPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => diContainer<ArticlesBloc>(),
        child: BlocConsumer<ArticlesBloc, ArticlesState>(
          listener: (context, state) {
            if (state is Error) {
              print("Build Page: Error");
              Navigator.pop(context);
              AlertSnackbar(context).showErrorSnackBar(label: state.message);
            } else if (state is NetworkError) {
              AlertSnackbar(context).showWarningSnackBar(label: state.message);
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
              return ArticlePage(state.article);
            } else if (state is ReloadedArticle) {
              print("Build Page Articles: Reloaded");
              return ArticlePage(state.article);
            } else if (state is FollowedHyperlink) {
              print("Build Page Articles: FollowedHyperlink");
              return ArticlePage(state.article);
            } else if (state is NetworkError) {
              BlocProvider.of<ArticlesBloc>(context).add(GetCachedArticles());
              return NoResultCard(
                label: state.message,
                onRefresh: () async {
                  BlocProvider.of<ArticlesBloc>(context)
                      .add(GetCachedArticles());
                },
              );
            } else if (state is Error) {
              return NoResultCard(
                label: state.message,
                onRefresh: () async {
                  BlocProvider.of<ArticlesBloc>(context)
                      .add(GetCachedArticles());
                },
              );
            } else {
              print("Build Page Articles: Undefined");
              // BlocProvider.of<ArticlesBloc>(context).add(RefreshArticle(url));
              return LoadingIndicator();
            }
          },
        ),
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
