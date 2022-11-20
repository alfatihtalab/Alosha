import 'package:alosha/app_provider.dart';
import 'package:alosha/page_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class ErrorConnectionPage extends StatelessWidget {
  const ErrorConnectionPage({Key? key}) : super(key: key);
  static const routeName = '/errorNoConnectionPage';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              const Icon(Icons.wifi_off, size: 100,),
              const SizedBox(height: 20,),
              const Text("It seems like no connection please check your network status!"
                ,textAlign: TextAlign.center,),
              // const SizedBox(height: 20,),


              const SizedBox(height: 30,),

              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AppProvider();
                }));
              },
                  child: const Text("Try again"))
            ],
          ),
        ),
      ),
    );
  }
}