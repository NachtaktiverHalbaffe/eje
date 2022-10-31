// ignore_for_file: camel_case_types

import 'package:eje/core/utils/injection_container.dart';
import 'package:eje/pages/articles/articles_page.dart';
import 'package:eje/pages/articles/domain/entity/Hyperlink.dart';
import 'package:eje/pages/articles/presentation/bloc/articles_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HyperlinkSection extends StatelessWidget {
  final List<Hyperlink> hyperlinks;
  const HyperlinkSection({Key key, this.hyperlinks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                color: Theme.of(context).colorScheme.secondary,
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
            return _column(hyperlinks[index]);
          },
          itemCount: hyperlinks.length,
        ),
      ],
    );
  }
}

class _column extends StatelessWidget {
  final Hyperlink hyperlink;
  const _column(this.hyperlink);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (hyperlink.link.contains("fileadmin") ||
            !hyperlink.link.contains("https://www.eje-esslingen.de")) {
          if (await canLaunchUrlString(hyperlink.link)) {
            await launchUrlString(hyperlink.link);
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
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          // ignore: unnecessary_this
          this.itemCount,
          // ignore: unnecessary_this
          (index) => this.itemBuilder(context, index)).toList(),
    );
  }
}
