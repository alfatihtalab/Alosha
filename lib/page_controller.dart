import 'package:alosha/error_connection.dart';
import 'package:alosha/web_page_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'internet_data_provider.dart';
class InternetPageController extends StatefulWidget {
  const InternetPageController({Key? key}) : super(key: key);

  @override
  State<InternetPageController> createState() => _InternetPageControllerState();
}

class _InternetPageControllerState extends State<InternetPageController> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isConnectedToInternet(),
        builder: (BuildContext context,AsyncSnapshot<bool> snapshot ){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.data!)
            {

              return WebViewPage();
            }else{
              return ErrorConnectionPage();
            }
          }


            return Scaffold(body: SafeArea(child: Center(child: CircularProgressIndicator(),),),);

          }
        );
  }


  Future<bool> _isConnectedToInternet()async{
    InternetProvider internetProvider = InternetProvider();
    final hasInternet = await internetProvider.checkInternetConnection();
    bool isLoaded = false;


    if(!hasInternet){
      isLoaded = false;
    }
    else{
      isLoaded = true;
    }
    return isLoaded;

  }
}
