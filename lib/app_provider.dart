
import 'package:alosha/page_controller.dart';
import 'package:alosha/web_page_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'error_connection.dart';
import 'package:flutter/cupertino.dart';


class AppProvider extends StatelessWidget {
  AppProvider({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          title: 'GoRouter Example',
        );
  }

  // routes of the page using new lib go_router
  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return  InternetPageController();
        },
      ),
      GoRoute(
        path: '/web_page',
        builder: (BuildContext context, GoRouterState state) {
          return const WebViewPage();
        },
      ),
      GoRoute(
        path: '/errorPage',
        builder: (BuildContext context, GoRouterState state) {
          return const ErrorConnectionPage();
        },
      ),
    ],
  );

}