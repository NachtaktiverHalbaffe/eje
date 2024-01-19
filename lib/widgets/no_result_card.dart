import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NoResultCard extends StatelessWidget {
  final String label;
  final bool isError;
  final double scale;
  final Future<void> Function() onRefresh;
  const NoResultCard(
      {required this.label,
      this.isError = false,
      this.scale = 1.0,
      required this.onRefresh})
      : super();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: GlobalKey<RefreshIndicatorState>(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0 * scale),
          height:
              scale == 1.0 ? MediaQuery.of(context).size.height - 50.0 : null,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isError ? MdiIcons.alertCircle : MdiIcons.alertDecagram,
                  size: 256 * scale,
                ),
                SizedBox(height: 12 * scale),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: scale != 1.0 ? (24 * scale) : 24,
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
