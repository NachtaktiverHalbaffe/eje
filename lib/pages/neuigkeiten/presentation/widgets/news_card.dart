import 'dart:ui';
import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/core/widgets/cached_image.dart';
import 'package:eje/pages/neuigkeiten/domain/entitys/news.dart';
import 'package:eje/pages/neuigkeiten/presentation/bloc/bloc.dart';
import 'package:eje/pages/neuigkeiten/presentation/widgets/news_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class NewsCard extends StatefulWidget {
  final News singleNews;
  NewsCard(this.singleNews);

  @override
  State createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  double sigmax = 0;

  double sigmay = 0;

  final _currentPageNotifier = ValueNotifier<int>(0);

  final GlobalKey expansionTile = GlobalKey();

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
                      value: sl<NewsBloc>(),
                      child: NewsDetails(widget.singleNews.title),
                    ),
                  ),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  color: Theme.of(context).colorScheme.surface,
                  child: PageView.builder(
                    physics: ScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    onPageChanged: (int index) {
                      _currentPageNotifier.value = index;
                    },
                    pageSnapping: true,
                    controller: PageController(initialPage: 0),
                    itemCount: widget.singleNews.images.length,
                    itemBuilder: (context, position) {
                      final bild = widget.singleNews.images[position];
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          CachedImage(url: bild),
                        ],
                      );
                    },
                  ),
                ),
              ),
              // ignore: missing_return
              Container(child: () {
                if (widget.singleNews.images.length != 1) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    child: CirclePageIndicator(
                      size: 5,
                      selectedSize: 7.5,
                      dotColor: Colors.white,
                      selectedDotColor: Theme.of(context).colorScheme.secondary,
                      itemCount: widget.singleNews.images.length,
                      currentPageNotifier: _currentPageNotifier,
                    ),
                  );
                }
              }()),
              Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: sl<NewsBloc>(),
                      child: NewsDetails(widget.singleNews.title),
                    ),
                  ),
                ),
                child: Theme(
                  data: theme,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: sigmax, sigmaY: sigmay),
                    child: ExpansionTile(
                      onExpansionChanged: (isExpanded) => _setBlur(isExpanded),
                      iconColor: Theme.of(context).colorScheme.secondary,
                      title: Text(
                        widget.singleNews.title.toString(),
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
                        Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 12, right: 12),
                              width: MediaQuery.of(context).size.width,
                              height: 130,
                              child: SingleChildScrollView(
                                child: Text(
                                  widget.singleNews.textPreview.toString(),
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
                              height: 12,
                            ),
                          ],
                        ),
                        //Inhalt, der gezeigt wird wenn expanded
                      ],
                    ),
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
