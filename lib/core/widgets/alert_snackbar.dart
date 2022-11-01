import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AlertSnackbar {
  final BuildContext context;
  final Duration duration = Duration(seconds: 3);
  final EdgeInsets margin = EdgeInsets.symmetric(horizontal: 12, vertical: 70);
  final ShapeBorder shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  AlertSnackbar(this.context);

  void showErrorSnackBar({required String label}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(MdiIcons.alertCircle),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          shape: shape,
          margin: margin,
          behavior: SnackBarBehavior.floating,
          duration: duration,
          elevation: 6,
        ),
      );
  }

  void showWarningSnackBar({required String label}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(MdiIcons.alert),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.yellow,
          shape: shape,
          margin: margin,
          behavior: SnackBarBehavior.floating,
          duration: duration,
          elevation: 6,
        ),
      );
  }
}
