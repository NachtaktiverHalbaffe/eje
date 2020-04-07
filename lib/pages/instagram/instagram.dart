import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Instagram extends StatefulWidget {
  @override
  _InstagramState createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> {
  WebViewController _controller;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: WebView(
              key: _key,
              initialUrl: "https://www.instagram.com/ejw_esslingen/",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController c) {
                _controller = c;
              },
            ),
          ),
        ],
      ),
    );
  }
}
