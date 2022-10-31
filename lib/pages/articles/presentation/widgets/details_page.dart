import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/articles/presentation/bloc/articles_bloc.dart';
import 'package:eje/pages/articles/presentation/widgets/hyperlink_section.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/widgets/cached_image.dart';
import '../../articles_page.dart';

// ignore: non_constant_identifier_names
class DetailsPage extends StatelessWidget {
  final String titel;
  final String untertitel;
  final String text;
  final List<String> bilder;
  final double pictureHeight;
  final List<Hyperlink> hyperlinks;

  final Widget childWidget;

  DetailsPage(
      {Key key,
      this.titel,
      this.untertitel = "",
      this.text,
      this.bilder,
      this.pictureHeight = 300,
      this.hyperlinks,
      this.childWidget});

  @override
  Widget build(BuildContext context) {
    final _currentPageNotifier = ValueNotifier<int>(0);

    // Widget itself
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        physics: ScrollPhysics(parent: RangeMaintainingScrollPhysics()),
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: pictureHeight,
                child: PageView.builder(
                  physics: ScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  onPageChanged: (int index) {
                    _currentPageNotifier.value = index;
                  },
                  pageSnapping: true,
                  controller: PageController(initialPage: 0),
                  itemCount: bilder.isNotEmpty ? bilder.length : 1,
                  itemBuilder: (context, position) {
                    String bild = "";
                    if (bilder.isNotEmpty) {
                      bild = bilder[position];
                    }
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        CachedImage(url: bild),
                      ],
                    );
                  },
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  child: () {
                    if (bilder.length != 1) {
                      return Container(
                        padding: EdgeInsets.all(8),
                        child: CirclePageIndicator(
                          size: 5,
                          selectedSize: 7.5,
                          dotColor: Colors.white,
                          selectedDotColor:
                              Theme.of(context).colorScheme.secondary,
                          itemCount: bilder.length,
                          currentPageNotifier: _currentPageNotifier,
                        ),
                      );
                    }
                  }()),
              Positioned(
                left: 16,
                top: 16,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: IconShadowWidget(
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
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
                        width: 12,
                      ),
                      Flexible(
                        child: Text(
                          titel,
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 17,
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
                    ],
                  ),
                  untertitel != ""
                      ? Container(
                          padding: EdgeInsets.only(left: 12, top: 8, right: 12),
                          child: Text(
                            untertitel,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 17,
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
                        )
                      : SizedBox(height: 2),
                  SizedBox(
                    height: 12,
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          text != null
              ? Container(
                  padding: EdgeInsets.only(
                    left: 14,
                    top: 14,
                    right: 14,
                  ),
                  child: MarkdownBody(
                    styleSheet: MarkdownStyleSheet(
                      textAlign: WrapAlignment.spaceEvenly,
                      h1Align: WrapAlignment.start,
                      h2Align: WrapAlignment.start,
                      h3Align: WrapAlignment.start,
                      tableCellsPadding: EdgeInsets.symmetric(horizontal: 8),
                      tableColumnWidth: IntrinsicColumnWidth(),
                      tableHead: TextStyle(fontWeight: FontWeight.normal),
                      tableBorder: TableBorder.all(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    shrinkWrap: true,
                    data: text,
                    onTapLink: (text, url, title) {
                      if (url.contains("eje-esslingen.de") &&
                          !url.contains("fileadmin/")) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: sl<ArticlesBloc>(),
                              child: ArticlesPage(
                                url: url,
                              ),
                            ),
                          ),
                        );
                      } else {
                        launchUrlString(url);
                      }
                    },
                  ),
                )
              : SizedBox(height: 8),
          SizedBox(height: 16),
          childWidget,
          hyperlinks[0].link != ""
              ? HyperlinkSection(hyperlinks: hyperlinks)
              : SizedBox(height: 8),
          SizedBox(height: 16)
        ],
      ),
    );
  }
}
