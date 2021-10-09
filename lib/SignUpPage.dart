import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_managment_app/main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

TextEditingController userName = new TextEditingController();
TextEditingController mobileNo = new TextEditingController();
TextEditingController email = new TextEditingController();
TextEditingController password = new TextEditingController();

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task Management"),
        backgroundColor: Colors.indigo.shade900,
        leading: Icon(Icons.format_list_bulleted),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 20),
              child: Text(
                "Add your details here",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 350,
                child: TextFormField(
                    controller: userName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "User name",
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
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: 350,
                child: TextFormField(
                    controller: mobileNo,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Mobile no",
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
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: 350,
                child: TextFormField(
                    controller: email,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: " e-mail",
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
              padding: const EdgeInsets.all(18.0),
              child: Container(
                width: 350,
                child: TextFormField(
                    controller: password,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Password",
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
            GestureDetector(
              onTap: () async {
                print("Submit Button Pressed ");
                SharedPreferences pref = await SharedPreferences.getInstance();
                var storedValue = pref.getString('API_KEY');
                print("API Key is ____________$storedValue");
                var resp = await http.post(
                    Uri.parse("http://192.168.29.16:3000/auth/signup"
                        // "http://192.168.43.34:3000/auth/signin"
                        ),
                    headers: {
                      "Authorization": "bearer $storedValue"
                    },
                    body: {
                      "username": userName.text.toString(),
                      "mobile": mobileNo.text.toString(),
                      "email": email.text.toString(),
                      "password":password.text.toString()
                    });
                print(resp.statusCode);
                print(resp.body);
                if(resp.statusCode ==409){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return new AlertDialog(
                          title: Text("Username already found ",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 13),),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32.0))),
                        );
                      });
                }
                // var st = 201;
                else if(resp.statusCode ==201){

                  print("Successfully added to db");
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return new AlertDialog(
                          title: new Text("Registered Successfully",style: TextStyle(fontSize: 16),),
                          actions: [
                            FlatButton(
                              textColor: Colors.blueAccent,
                              onPressed: () {
                                print("___________Buttom Pressed _________");
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => MyHomePage(title: "Task Management",)));                              },
                              child: Text('Go to Login',style: TextStyle(fontSize: 16),),
                            ),
                          ],
                        );
                      });
                }

              },
              child: Container(
                width: 130,
                height: 40,
                // color: Colors.indigo.shade900,
                decoration: BoxDecoration(
                    color: Colors.indigo.shade900,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Register",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
