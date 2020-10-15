import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';

Widget DetailsPage(
    {String titel,
    String untertitel,
    String text,
    String bild_url,
    BuildContext context,
    Widget child_widget}) {
  return ListView(
    physics: ScrollPhysics(parent: BouncingScrollPhysics()),
    children: <Widget>[
      Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1050 / MediaQuery.of(context).devicePixelRatio,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: ExactAssetImage(bild_url),
              ),
            ),
          ),
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
                  Text(
                    titel,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 120 / MediaQuery.of(context).devicePixelRatio,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 6.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              untertitel != null
                  ? Container(
                      padding: EdgeInsets.only(
                          left: 36 / MediaQuery.of(context).devicePixelRatio,
                          top: 36 / MediaQuery.of(context).devicePixelRatio),
                      child: Text(
                        untertitel,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize:
                              60 / MediaQuery.of(context).devicePixelRatio,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 6.0,
                              color: Colors.black,
                            ),
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 6.0,
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
              padding:
                  EdgeInsets.all(42 / MediaQuery.of(context).devicePixelRatio),
              child: Text(
                text,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
                ),
              ),
            )
          : SizedBox(height: 24 / MediaQuery.of(context).devicePixelRatio),
      child_widget,
    ],
  );
}
