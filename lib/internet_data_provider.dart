
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class InternetProvider extends ChangeNotifier {
  late bool _hasInternet ;
  bool get hasInternet => _hasInternet;


  Future<bool> checkInternetConnection() async {
    bool hasInternet = false;
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      hasInternet = false;
    } else {
      hasInternet = true;
    }
    return hasInternet;
  }
}