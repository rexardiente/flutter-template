// ignore_for_file: public_member_api_docs
import 'dart:async';
// import 'dart:ffi';
import 'dart:io';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
// import 'package:webview_flutter_android/webview_flutter_android.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const MyWebView(),
  ));
}

class MyWebView extends StatefulWidget {
  const MyWebView({super.key});

  @override
  State<MyWebView> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<MyWebView> {
  var loadingPercentage = 0;
  final loadingAnimation = 4;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('random')
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) async {
          setState(() {
            loadingPercentage = 100;
          });
        },
        onUrlChange: (change) async {
          if (change.url!
              .startsWith('https://accounts.google.com/signin/v2/challenge/')) {
            if (await controller.canGoForward()) {
              // disable loading to other screen on signin submit
              controller.goForward().then((res) => controller.runJavaScript(
                  'document.getElementById("signInSubmit").click();'));
              NavigationDecision.prevent;
            }
          }
          NavigationDecision.navigate;
        },
      ))
      ..loadRequest(
        Uri.parse('https://flutter.dev/'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          // appBar: AppBar(
          //   title: const Text('ChatGPT'),
          //   centerTitle: true,
          // ),
          body: FutureBuilder(
            future: Future.delayed(Duration(seconds: loadingAnimation), () {
              return loadingPercentage;
            }),
            builder: (context, snapshot) {
              return SafeArea(
                child: loadingPercentage == 100
                    ? WebViewWidget(
                        controller: controller,
                      )
                    : Center(
                        // check if platform is Android or IOS
                        child: Platform.isAndroid
                            ? TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                    begin: 0.0,
                                    end: loadingAnimation.toDouble()),
                                duration: const Duration(milliseconds: 3500),
                                builder: (context, value, _) =>
                                    CircularProgressIndicator(value: value),
                              )
                            : const CupertinoActivityIndicator(),
                      ),
              );
            },
          ),
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            minHeight: 5,
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}
