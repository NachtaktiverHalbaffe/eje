import 'dart:ui';
import 'package:eje/models/news.dart';
import 'package:eje/utils/injection_container.dart';
import 'package:eje/widgets/cached_image.dart';
import 'package:eje/widgets/pages/news/bloc/news_bloc.dart';
import 'package:eje/widgets/pages/news/news_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class NewsCard extends StatefulWidget {
  final News singleNews;
  NewsCard({required this.singleNews});

  @override
  State createState() => _NewsCardState(singleNews: singleNews);
}

class _NewsCardState extends State<NewsCard> {
  final News singleNews;
  double sigmax = 0;
  double sigmay = 0;
  final _currentPageNotifier = ValueNotifier<int>(0);
  final GlobalKey expansionTile = GlobalKey();

  _NewsCardState({required this.singleNews});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Container(
      padding: EdgeInsets.only(left: 12, top: 12, right: 12),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            //background color of box
            BoxShadow(
              color: Colors.black,
              blurRadius: 10.0, // soften the shadow
              spreadRadius: 0.25, //extend the shadow
              offset: Offset(
                2, // Move to right 10  horizontally
                2, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: diContainer<NewsBloc>(),
                      child: NewsDetails(singleNews.link),
                    ),
                  ),
                ),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    color: Theme.of(context).colorScheme.surface,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        CachedImage(url: singleNews.images[0]),
                      ],
                    )),
              ),
              Theme(
                data: theme,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: sigmax, sigmaY: sigmay),
                  child: ExpansionTile(
                    onExpansionChanged: (isExpanded) => _setBlur(isExpanded),
                    iconColor: Theme.of(context).colorScheme.secondary,
                    title: Text(
                      singleNews.title.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 6,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 6,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: diContainer<NewsBloc>(),
                              child: NewsDetails(singleNews.link),
                            ),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              width: MediaQuery.of(context).size.width,
                              height: 130,
                              child: SingleChildScrollView(
                                child: Text(
                                  singleNews.textPreview.toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 6,
                                        color: Colors.black,
                                      ),
                                      Shadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 6,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setBlur(bool isExpanded) {
    if (isExpanded) {
      setState(() {
        sigmax = 4;
      });
      setState(() {
        sigmay = 4;
      });
    } else {
      setState(() {
        sigmax = 0;
      });
      setState(() {
        sigmay = 0;
      });
    }
  }
}
