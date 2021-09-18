import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

// ignore: non_constant_identifier_names
class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).colorScheme.background,
              )
            : CupertinoActivityIndicator(),
      ),
    );
  }
}
