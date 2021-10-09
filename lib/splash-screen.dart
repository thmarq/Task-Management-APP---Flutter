import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:task_managment_app/main.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 8,
      title: Text("Task Management",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      loadingText: Text("Loading ..."),
      loaderColor: Colors.blue,
      image: Image.network("https://www.pinclipart.com/picdir/big/578-5783998_clip-art-logo-maker.png"),
      photoSize: 100,
      navigateAfterSeconds: MyHomePage(title: 'Task Management',)
    );
  }
}
