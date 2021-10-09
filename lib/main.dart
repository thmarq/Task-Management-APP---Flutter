import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_managment_app/models/login-success.dart';
import 'package:task_managment_app/splash-screen.dart';

import 'SignUpPage.dart';
import 'homePage.dart';
import 'models/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MyHomePage(title: 'Task Management'),
      home: Splash(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  storeApiKey(data) async {
    print("DATA RECIEVED________" + data.toString());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var d = await pref.setString("API_KEY", data.toString());
    var storedValue = pref.getString('API_KEY');
    print("___________storedValue ___________$storedValue");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        backgroundColor: Colors.indigo.shade900,
        leading: Icon(Icons.format_list_bulleted),
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20),
              child: Container(
                width: 350,
                child: TextFormField(
                    controller: username,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Username",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueAccent.shade200,
                          width: 2.0,
                        ),
                      ),
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Container(
                width: 350,
                child: TextFormField(
                    controller: password,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    )),
              ),
            ),
            GestureDetector(
              onTap: () async {
                print("Button Pressed " + username.text.toString());
                var resp = await http.post(
                    Uri.parse("http://192.168.29.16:3000/auth/signin"
                        // "http://192.168.43.34:3000/auth/signin"
                        ),
                    body: {
                      "username": username.text.toString(),
                      "password": password.text.toString()
                    });
                print(resp.statusCode);

                if (resp.statusCode == 400) {
                  var data = UserLogin.fromJson(jsonDecode(resp.body));
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return new AlertDialog(
                          title: new Text("Bad Request"),
                          content: new Text(data.message[0]),
                        );
                      });
                } else {
                  var loginSuccessData =
                      LoginSuccess.fromJson(jsonDecode(resp.body));
                  storeApiKey(loginSuccessData.accessToken);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return new AlertDialog(
                          title: new Text("Login Success !!"),
                        );
                      });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  width: 100,
                  height: 40,
                  // color: Colors.indigo.shade900,
                  decoration: BoxDecoration(
                      color: Colors.indigo.shade900,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 130,
                height: 180,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 20),
                      child: Text(
                        "Create new account",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Button Sign Up pressed");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUpPage()));
                      },
                      child: Container(
                        width: 250,
                        height: 40,
                        // color: Colors.indigo.shade900,
                        decoration: BoxDecoration(
                            color: Colors.greenAccent.shade700,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "Sign Up",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
