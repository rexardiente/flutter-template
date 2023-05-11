import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.

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
  final loadingAnimation = 1;
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
            // future: Future.delayed(Duration(seconds: loadingAnimation), () {
            //   return loadingPercentage;
            // }),
            builder: (context, snapshot) {
              return SafeArea(
                child: loadingPercentage == 100
                    ? WebViewWidget(
                        controller: controller,
                      )
                    : Center(
                        // check if platform is Android or IOS
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                              begin: 0.0, end: loadingAnimation.toDouble()),
                          duration: const Duration(seconds: 3),
                          curve: Curves.easeOut,
                          builder: (BuildContext buildContext, double? value,
                              Widget? child) {
                            // Desired width and height for the image and CircularProgressIndicator
                            const double imageSize = 100.0;
                            return SizedBox(
                              width: imageSize,
                              height: imageSize,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Image widget with opacity controlled by the tween
                                  Opacity(
                                    // Note: opacity wont allow > 1.0 or < 0.0
                                    opacity: value != null &&
                                            value >= 0.0 &&
                                            value <= 1.0
                                        ? value
                                        : 0.0,
                                    child: Image.asset(
                                      'assets/chatgpt_icon.png',
                                      width: imageSize,
                                      height: imageSize,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // use aspect ratio 1-1 to make square
                                  // TweenAnimationBuilder<double>(
                                  //   tween: Tween<double>(
                                  //       begin: 0.0,
                                  //       end: loadingAnimation.toDouble()),
                                  //   duration: const Duration(seconds: 3),
                                  //   builder: (context, value, _) => SizedBox(
                                  //     width: imageSize,
                                  //     height: imageSize,
                                  //     child: Opacity(
                                  //       opacity: value >= 0.0 && value <= 1.0
                                  //           ? value
                                  //           : 0.0,
                                  //       child: Platform.isAndroid
                                  //           ? CircularProgressIndicator(
                                  //               color: const Color.fromARGB(
                                  //                   255, 22, 162, 127),
                                  //               value: value)
                                  //           : CupertinoActivityIndicator(
                                  //               color: Colors.green[700],
                                  //             ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              );
            },
          ),
        ),
        // if (loadingPercentage < 100)
        //   LinearProgressIndicator(
        //     minHeight: 5,
        //     value: loadingPercentage / 100.0,
        //   ),
      ],
    );
  }
}
