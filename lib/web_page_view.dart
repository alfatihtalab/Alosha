import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  // final String url;
  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));
  bool isSearchFocus = false;
  late TextEditingController _searchController;
  late FocusNode focusNode;

  late PullToRefreshController pullToRefreshController;
  String url = "https://alosha.ae";
  double progress = 0;
  String title = "Main page";

  UniqueKey uniqueKeyP = UniqueKey();

  // final urlController = TextEditingController();
  Future<bool> showExitPopup(BuildContext context) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit an App?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                //return false when click on "NO"
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  //go back function

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    focusNode = FocusNode();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showExitPopup(context);
      },
      key: uniqueKeyP,
      child: Container(
        child: Scaffold(
          appBar:AppBar(
            title:  Text(title),
          ),
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                      // color: Color(0xff13649F ),
                      ),
                  child: Text(
                    'Alosha Fashion',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Main page'),
                  onTap: () {
                    setState(() async {
                      title = "Main page";
                      webViewController!.loadUrl(
                          urlRequest: URLRequest(
                              url: Uri.parse("https://www.alosha.ae/")));
                    });
                  },
                ),
                ListTile(
                  title: const Text('Women collection'),
                  onTap: () {
                    setState(() async {
                      title = "Women collection";
                      url = "https://alosha.ae/collections/women";
                      webViewController!
                          .loadUrl(urlRequest: URLRequest(url: Uri.parse(url)));
                    });
                  },
                ),
                ListTile(
                  title: const Text('Men collection'),
                  onTap: () {
                    setState(() async {
                      title = "Men collection";

                      url = "https://alosha.ae/collections/women";
                      webViewController!.loadUrl(
                          urlRequest: URLRequest(
                              url: Uri.parse(
                                  "https://www.alosha.ae/collections/men-collection")));
                    });
                  },
                ),
                ListTile(
                  title: Text('Kids collection'),
                  onTap: () {
                    setState(() async {
                      title = "Kids collection";

                      webViewController!.loadUrl(
                          urlRequest: URLRequest(
                              url: Uri.parse(
                                  "https://www.alosha.ae/collections/kids")));
                    });
                  },
                ),
                ListTile(
                  title: Text('Features collection'),
                  onTap: () {
                    setState(() async {
                      title = "Features collection";

                      webViewController!.loadUrl(
                          urlRequest: URLRequest(
                              url: Uri.parse(
                                  "https://www.alosha.ae/collections/featured-collection")));
                    });
                  },
                ),
                ListTile(
                  title: Text('Daily offers'),
                  onTap: () {
                    setState(() async {
                      title = "Daily collection";

                      webViewController!.loadUrl(
                          urlRequest: URLRequest(
                              url: Uri.parse(
                                  "https://www.alosha.ae/collections/daily-deals")));
                    });
                  },
                ),
                ListTile(
                  title: Text('Cart'),
                  onTap: () {
                    setState(() async {
                      title = "Cart";

                      webViewController!.loadUrl(
                          urlRequest: URLRequest(
                              url: Uri.parse("https://www.alosha.ae/cart")));
                    });
                  },
                ),
                // ListTile(
                //   title: Text('Account page'),
                //   onTap: () {
                //     setState(() async {
                //       title = "Account";
                //
                //       webViewController!.loadUrl(
                //           urlRequest: URLRequest(
                //               url: Uri.parse("https://www.alosha.ae/account")));
                //     });
                //   },
                // ),
              ],
            ),
          ),
          body: FutureBuilder(
              future: removeHeader(),
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!) {
                    return SafeArea(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text("Title", style: Theme.of(context).textTheme.titleLarge,),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       // mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         const SizedBox(
                          //           width: 3,
                          //         ),
                          //         Flexible(
                          //           flex: 2,
                          //           child: TextField(
                          //             // obscureText: true,
                          //             onChanged: (enteredKeyword) {},
                          //             onTap: () async {
                          //               setState(() {
                          //                 isSearchFocus = true;
                          //               });
                          //             },
                          //
                          //             controller: _searchController,
                          //             focusNode: focusNode,
                          //             decoration: const InputDecoration(
                          //                 // border: OutlineInputBorder(),
                          //                 labelText: 'Search',
                          //                 icon: Icon(Icons.search)),
                          //           ),
                          //         ),
                          //         const SizedBox(
                          //           width: 3,
                          //         ),
                          //         isSearchFocus
                          //             ? IconButton(
                          //                 onPressed: () async {
                          //                   // await newsProvider.getNewsDataFromApi(sectionName: dropdownValue);
                          //
                          //                   setState(() {
                          //                     isSearchFocus = false;
                          //                     _searchController.clear();
                          //                     FocusScope.of(context).unfocus();
                          //                   });
                          //                 },
                          //                 icon: const Icon(Icons.close))
                          //             : Row(children: const [
                          //                 Icon(
                          //                   Icons.filter_list_alt,
                          //                   size: 20,
                          //                 ),
                          //                 SizedBox(
                          //                   width: 3,
                          //                 ),
                          //               ]),
                          //       ]),
                          // ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                InAppWebView(
                                  key: webViewKey,
                                  initialUrlRequest:
                                      URLRequest(url: Uri.parse(url)),
                                  initialOptions: options,
                                  pullToRefreshController:
                                      pullToRefreshController,
                                  onWebViewCreated: (controller) {
                                    webViewController = controller;
                                  },
                                  onLoadStart: (controller, url) {
                                    setState(() {
                                      // this.url = url.toString();
                                    });
                                  },
                                  androidOnPermissionRequest:
                                      (controller, origin, resources) async {
                                    return PermissionRequestResponse(
                                        resources: resources,
                                        action: PermissionRequestResponseAction
                                            .GRANT);
                                  },
                                  shouldOverrideUrlLoading:
                                      (controller, navigationAction) async {
                                    var uri = navigationAction.request.url!;

                                    if (![
                                      "http",
                                      "https",
                                      "file",
                                      "chrome",
                                      "data",
                                      "javascript",
                                      "about"
                                    ].contains(uri.scheme)) {
                                      if (await canLaunchUrl(Uri.parse(url))) {
                                        // Launch the App
                                        await launchUrl(
                                          Uri.parse(url),
                                        );
                                        // and cancel the request
                                        return NavigationActionPolicy.CANCEL;
                                      }
                                    }

                                    return NavigationActionPolicy.ALLOW;
                                  },
                                  onLoadStop: (controller, url) async {
                                    pullToRefreshController.endRefreshing();
                                    setState(() {
                                      // this.url = url.toString();
                                      // urlController.text = this.url;
                                    });
                                  },
                                  onLoadError:
                                      (controller, url, code, message) {
                                    pullToRefreshController.endRefreshing();
                                  },
                                  onProgressChanged: (controller, progress) {
                                    if (progress == 100) {
                                      pullToRefreshController.endRefreshing();
                                    }
                                    setState(() {
                                      this.progress = progress / 100;
                                      // urlController.text = this.url;
                                    });
                                  },
                                  onUpdateVisitedHistory:
                                      (controller, url, androidIsReload) {
                                    setState(() {
                                      this.url = url.toString();
                                      // urlController.text = this.url;
                                    });
                                  },
                                  onConsoleMessage:
                                      (controller, consoleMessage) {
                                    print(consoleMessage);
                                  },
                                ),
                                progress < 1.0
                                    ? LinearProgressIndicator(value: progress)
                                    : Container(),
                              ],
                            ),
                          ),
                        ]));

                    // floatingActionButton: FloatingActionButton(onPressed: () {
                    //
                    // },
                    // child: Text("test"),),

                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }

  Future<bool> removeHeader() async {
    webViewController?.evaluateJavascript(
        source:
            "document.getElementsByTagName('header')[0].style.display='none';");
    // if(title == "Account"){
    //   webViewController?.evaluateJavascript(
    //       source:
    //       "document.getElementsByTagName('header')[0].style.display='none';");
    // }
    return Future.value(true);
  }
}
