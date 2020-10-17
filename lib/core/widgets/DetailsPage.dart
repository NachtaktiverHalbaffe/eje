import 'package:eje/core/widgets/HyperlinkSection.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import 'PrefImage.dart';

// ignore: non_constant_identifier_names
class DetailsPage extends StatelessWidget {
  final String titel;
  final String untertitel;
  final String text;
  final List<String> bild_url;
  final double pixtureHeight;
  final List<Hyperlink> hyperlinks;
  final bool isCacheEnabled;
  final Widget childWidget;

  DetailsPage(
      {Key key,
      this.titel,
      this.untertitel,
      this.text,
      this.bild_url,
      this.pixtureHeight = 0,
      this.hyperlinks,
      this.isCacheEnabled = false,
      this.childWidget});

  @override
  Widget build(BuildContext context) {
    final _currentPageNotifier = ValueNotifier<int>(0);
    return Scaffold(
      body: ListView(
        physics: ScrollPhysics(parent: BouncingScrollPhysics()),
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: pixtureHeight == 0
                    ? 900 / MediaQuery.of(context).devicePixelRatio
                    : 1200 / MediaQuery.of(context).devicePixelRatio,
                child: PageView.builder(
                  physics: ScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  onPageChanged: (int index) {
                    _currentPageNotifier.value = index;
                  },
                  pageSnapping: true,
                  controller: PageController(initialPage: 0),
                  itemCount: bild_url.length,
                  itemBuilder: (context, position) {
                    final bild = bild_url[position];
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: bild.contains("http")
                                  ? PrefImage(bild, isCacheEnabled)
                                  : ExactAssetImage(bild),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: () {
                    if (bild_url.length != 1) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        child: CirclePageIndicator(
                          size: 5,
                          selectedSize: 7.5,
                          dotColor: Colors.white,
                          selectedDotColor: Theme.of(context).accentColor,
                          itemCount: bild_url.length,
                          currentPageNotifier: _currentPageNotifier,
                        ),
                      );
                    }
                  }()),
              Positioned(
                left: 48.0 / MediaQuery.of(context).devicePixelRatio,
                top: 48.0 / MediaQuery.of(context).devicePixelRatio,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: IconShadowWidget(
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 72 / MediaQuery.of(context).devicePixelRatio,
                    ),
                    showShadow: true,
                    shadowColor: Colors.black,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 36 / MediaQuery.of(context).devicePixelRatio,
                      ),
                      Flexible(
                        child: Text(
                          titel,
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize:
                                100 / MediaQuery.of(context).devicePixelRatio,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(
                                    6 / MediaQuery.of(context).devicePixelRatio,
                                    6 /
                                        MediaQuery.of(context)
                                            .devicePixelRatio),
                                blurRadius: 18 /
                                    MediaQuery.of(context).devicePixelRatio,
                                color: Colors.black,
                              ),
                              Shadow(
                                offset: Offset(
                                    6 / MediaQuery.of(context).devicePixelRatio,
                                    6 /
                                        MediaQuery.of(context)
                                            .devicePixelRatio),
                                blurRadius: 18 /
                                    MediaQuery.of(context).devicePixelRatio,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  untertitel != ""
                      ? Container(
                          padding: EdgeInsets.only(
                              left:
                                  36 / MediaQuery.of(context).devicePixelRatio,
                              top:
                                  24 / MediaQuery.of(context).devicePixelRatio),
                          child: Text(
                            untertitel,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize:
                                  60 / MediaQuery.of(context).devicePixelRatio,
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(
                                      6 /
                                          MediaQuery.of(context)
                                              .devicePixelRatio,
                                      6 /
                                          MediaQuery.of(context)
                                              .devicePixelRatio),
                                  blurRadius: 18 /
                                      MediaQuery.of(context).devicePixelRatio,
                                  color: Colors.black,
                                ),
                                Shadow(
                                  offset: Offset(
                                      6 /
                                          MediaQuery.of(context)
                                              .devicePixelRatio,
                                      6 /
                                          MediaQuery.of(context)
                                              .devicePixelRatio),
                                  blurRadius: 18 /
                                      MediaQuery.of(context).devicePixelRatio,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 6 / MediaQuery.of(context).devicePixelRatio),
                  SizedBox(
                    height: 36 / MediaQuery.of(context).devicePixelRatio,
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 24 / MediaQuery.of(context).devicePixelRatio),
          text != null
              ? Container(
                  padding: EdgeInsets.all(
                      42 / MediaQuery.of(context).devicePixelRatio),
                  child: Text(
                    text,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
                    ),
                  ),
                )
              : SizedBox(height: 24 / MediaQuery.of(context).devicePixelRatio),
          childWidget,
          hyperlinks[0].link != ""
              ? HyperlinkSection(
                  hyperlinks: hyperlinks,
                  isCacheEnabled: isCacheEnabled,
                  context: context)
              : SizedBox(height: 24 / MediaQuery.of(context).devicePixelRatio),
          SizedBox(height: 48 / MediaQuery.of(context).devicePixelRatio)
        ],
      ),
    );
  }
}
