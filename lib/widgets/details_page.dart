import 'package:auto_size_text/auto_size_text.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:eje/models/Hyperlink.dart';
import 'package:eje/utils/injection_container.dart';
import 'package:eje/widgets/cached_image.dart';
import 'package:eje/widgets/hyperlink_section.dart';
import 'package:eje/widgets/pages/articles/articles_page.dart';
import 'package:eje/widgets/pages/articles/bloc/articles_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
      {required this.titel,
      this.untertitel = "",
      this.text = "",
      required this.bilder,
      this.pictureHeight = 300,
      required this.hyperlinks,
      required this.childWidget});

  @override
  Widget build(BuildContext context) {
    final currentPageNotifier = ValueNotifier<int>(0);

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
                    currentPageNotifier.value = index;
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
                          currentPageNotifier: currentPageNotifier,
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
                  child: Center(
                    child: DecoratedIcon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
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
                        child: AutoSizeText(
                          titel,
                          textAlign: TextAlign.left,
                          maxLines: 1,
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
                          child: AutoSizeText(
                            untertitel,
                            maxLines: 2,
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
          Container(
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
              onTapLink: (text, url, title) async {
                if (url!.contains("eje-esslingen.de") &&
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
                  if (await canLaunchUrlString(url)) {
                    if (url.contains(".pdf") || url.contains(".doc")) {
                      launchUrlString(url,
                          mode: LaunchMode.externalApplication);
                    } else {
                      launchUrlString(url);
                    }
                  }
                }
              },
            ),
          ),
          SizedBox(height: 16),
          childWidget,
          hyperlinks.isNotEmpty
              ? HyperlinkSection(hyperlinks: hyperlinks)
              : SizedBox(height: 8),
          SizedBox(height: 16)
        ],
      ),
    );
  }
}
