import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NoResultCard extends StatelessWidget {
  final String label;
  final bool isError;
  final VoidCallback onRefresh;
  const NoResultCard(
      {Key key, @required this.label, this.isError = false, this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: GlobalKey<RefreshIndicatorState>(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          height: MediaQuery.of(context).size.height - 50.0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isError ? MdiIcons.alertCircle : MdiIcons.alertDecagram,
                  size: 256,
                ),
                SizedBox(height: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onRefresh: onRefresh,
    );
  }
}
