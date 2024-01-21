import 'package:eje/models/Article.dart';
import 'package:eje/widgets/alert_snackbar.dart';
import 'package:eje/widgets/details_page.dart';
import 'package:eje/widgets/loading_indicator.dart';
import 'package:eje/widgets/no_result_card.dart';
import 'package:eje/widgets/pages/news/bloc/news_bloc.dart';
import 'package:eje/widgets/pages/news/bloc/news_event.dart';
import 'package:eje/widgets/pages/news/bloc/news_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsDetails extends StatelessWidget {
  final String title;
  NewsDetails(this.title);

  @override
  Widget build(BuildContext context) {
    print(title);
    return Scaffold(
      body: BlocConsumer<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is Error) {
            AlertSnackbar(context).showErrorSnackBar(label: state.message);
            Navigator.pop(context);
          } else if (state is NetworkError) {
            AlertSnackbar(context).showErrorSnackBar(label: state.message);
            Navigator.pop(context);
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
            return Center();
          } else if (state is Error) {
            return NoResultCard(
              label: state.message,
              onRefresh: () async {
                BlocProvider.of<NewsBloc>(context).add(GetNewsDetails(title));
              },
            );
          } else if (state is NetworkError) {
            return NoResultCard(
              label: state.message,
              onRefresh: () async {
                BlocProvider.of<NewsBloc>(context).add(GetNewsDetails(title));
              },
            );
          } else if (state is Loading) {
            return LoadingIndicator();
          } else {
            // AlertSnackbar(context).showErrorSnackBar(
            //     label:
            //         "Konnte Details zur Neuigkeit nicht laden: Unbekannter Fehler");
            Navigator.pop(context);
            print(state);
            return NoResultCard(
              label:
                  "Konnte Details zur Neuigkeit nicht laden: Unbekannter Fehler",
              onRefresh: () async {
                BlocProvider.of<NewsBloc>(context).add(GetNewsDetails(title));
              },
            );
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
