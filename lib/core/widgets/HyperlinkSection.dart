import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/articles/articlesPage.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/articles/presentation/bloc/articles_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Widget HyperlinkSection(
    {List<Hyperlink> hyperlinks, BuildContext context, bool isCacheEnabled}) {
  return Column(
    children: [
      Row(
        children: [
          SizedBox(
            width: 14,
          ),
          Text(
            "Weiterführende Links",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 72 / MediaQuery.of(context).devicePixelRatio,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      SizedBox(
        height: 12,
      ),
      ColumnBuilder(
        itemBuilder: (context, index) {
          return _column(hyperlinks[index], context, isCacheEnabled);
        },
        itemCount: hyperlinks.length,
      ),
    ],
  );
}

Widget _column(Hyperlink hyperlink, BuildContext context, bool isCacheEnabled) {
  return GestureDetector(
    onTap: () async {
      if (hyperlink.link.contains("fileadmin") ||
          !hyperlink.link.contains("https://www.eje-esslingen.de")) {
        if (await canLaunch(hyperlink.link)) {
          await launch(hyperlink.link);
        } else {
          throw 'Could not launch $hyperlink.link';
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: sl<ArticlesBloc>(),
              child: ArticlesPage(
                url: hyperlink.link,
              ),
            ),
          ),
        );
      }
    },
    child: Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 14,
            ),
            Icon(
              MdiIcons.openInNew,
              color: Theme.of(context).dividerColor,
            ),
            SizedBox(
              width: 4,
            ),
            Flexible(
              child: Text(
                hyperlink.description,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 48 / MediaQuery.of(context).devicePixelRatio,
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 4,
        ),
      ],
    ),
  );
}

//ColumnBuilder for dynamically generation Columns
class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  final VerticalDirection verticalDirection;
  final int itemCount;

  const ColumnBuilder({
    Key key,
    @required this.itemBuilder,
    @required this.itemCount,
    this.mainAxisAlignment: MainAxisAlignment.start,
    this.mainAxisSize: MainAxisSize.max,
    this.crossAxisAlignment: CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection: VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: new List.generate(
          this.itemCount, (index) => this.itemBuilder(context, index)).toList(),
    );
  }
}
