// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_clone/generated/l10n.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    Key? key,
  }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewState();
}

class _WebViewState extends State<WebViewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            /*if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }*/
            return NavigationDecision.navigate;
          },
        ),
      );
    Future.delayed(Duration.zero, () {
      var arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      String? url = arguments["url"];

      if (url != null) {
        controller.loadRequest(Uri.parse(url));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String title = arguments['title'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        title: Text(title),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(controller),
        ],
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this.controller, {Key? key}) : super(key: key);

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            var scaffoldMessenger = ScaffoldMessenger.of(context);
            var s = S.of(context);
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text(s.no_back_history)),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            var scaffoldMessenger = ScaffoldMessenger.of(context);
            var s = S.of(context);
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text(s.no_forward_history)),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () {
            controller.reload();
          },
        ),
      ],
    );
  }
}
