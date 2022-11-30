import 'package:alosha/widgets/rounded_image.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
          child: Hero(
            tag: 'splashScreen',
            child: Center(
              child: AspectRatio(
                  aspectRatio: size.height * 0.30 / size.width * 0.30,
                  child: CircleImage(imageProvider: AssetImage('assets/logo.png',),imageRadius: 70,)),
            ),
          )),
    );
  }
}