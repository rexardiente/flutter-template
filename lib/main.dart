// ignore_for_file: public_member_api_docs
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: true),
    home: const MyWebView(),
  ));
}

class MyWebView extends StatefulWidget {
  const MyWebView({super.key});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatGPT Mobile'),
      ),
      body: WebView(
        initialUrl: 'https://accounts.google.com/signin',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) => _controller.complete(controller),
        navigationDelegate: (navigation) {
          if (navigation.url
              .startsWith('https://accounts.google.com/signin/v2/challenge/')) {
            _controller.future.then((controller) => controller.runJavascript(
                'document.getElementById("signInSubmit").click();'));
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
