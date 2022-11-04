import 'package:eje/pages/articles/presentation/widgets/details_page.dart';
import 'package:eje/core/widgets/loading_indicator.dart';
import 'package:eje/pages/articles/domain/entity/Article.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsDetails extends StatelessWidget {
  final String title;
  NewsDetails(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<NewsBloc, NewsState>(
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
          if (state is LoadedNewsDetails) {
            print("Build Page Neuigkeiten: LoadedDetail");
            return NewsCard(article: state.article);
          } else if (state is LoadingNewsDetails) {
            return LoadingIndicator();
          } else if (state is Empty) {
            BlocProvider.of<NewsBloc>(context).add(GetNewsDetails(title));
            return LoadingIndicator();
          } else {
            BlocProvider.of<NewsBloc>(context).add(GetNewsDetails(title));
            return LoadingIndicator();
          }
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final Article article;
  const NewsCard({required this.article}) : super();

  @override
  Widget build(BuildContext context) {
    // Merge all information from List<Article> to one data-entry
    return DetailsPage(
      titel: article.titel,
      untertitel: "",
      text: article.content,
      bilder: article.bilder,
      hyperlinks:
          article.hyperlinks.isEmpty ? List.empty() : article.hyperlinks,
      childWidget: SizedBox(
        height: 36 / MediaQuery.of(context).devicePixelRatio,
      ),
    );
  }
}
