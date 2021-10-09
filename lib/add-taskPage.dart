import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_managment_app/view-all-tasks.dart';

import 'homePage.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

TextEditingController taskName = new TextEditingController();
TextEditingController description = new TextEditingController();
TextEditingController status = new TextEditingController();

String _initialDropDownValue = "OPEN";
// List<dynamic> _statusValues = [
//   {"Open": "OPEN"},
//   {"In Progress": "INPROGRESS"}
// ];

List<String> dropDownValues = ["OPEN", "INPROGRESS", "CLOSED"];
String _selectedDropDownValue;

class _AddTaskPageState extends State<AddTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 20),
              child: Text(
                "You can add your task here",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                width: 350,
                child: TextFormField(
                    controller: taskName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Task name",
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
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                width: 350,
                child: TextFormField(
                    controller: description,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Description",
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
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  width: 350,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        labelText: "Status",
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.blueAccent.shade200,
                          width: 2.0,
                        ))),
                    onChanged: (String newValue) {
                      setState(() {
                        _initialDropDownValue = newValue;
                      });
                    },
                    items:
                        dropDownValues.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        onTap: () {
                          print("Drop down selected");
                          setState(() {
                            _selectedDropDownValue = value;
                          });
                        },
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            value,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
            ),
            GestureDetector(
              onTap: () async {
                print("Submit Button Pressed $_selectedDropDownValue");
                SharedPreferences pref = await SharedPreferences.getInstance();
                var storedValue = pref.getString('API_KEY');
                print("API Key is ____________$storedValue");
                var resp = await http.post(
                    Uri.parse("http://192.168.29.16:3000/tasks"
                        // "http://192.168.43.34:3000/auth/signin"
                        ),
                    headers: {
                      "Authorization": "bearer $storedValue"
                    },
                    body: {
                      "name": taskName.text.toString(),
                      "description": description.text.toString(),
                      "status": _selectedDropDownValue
                    });
                print(resp.statusCode);
                if (resp.statusCode == 201) {
                  print("Successfully added to db");
                  setState(() {});

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return new AlertDialog(
                          title: new Text(
                            "Task Added Successfully",
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: [
                            GestureDetector(
                              onTap:(){
                                print("Button pressed ");
                                Navigator.pop(context);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>HomePage()));
                                taskName.clear();
                                description.clear();
                                //     .then((value) => setState(() {}));
                                // Navigator.pop(context);

                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Okay',
                                  style: TextStyle(fontSize: 16 ,color: Colors.blueAccent.shade700,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                }
              },
              child: Container(
                width: 100,
                height: 45,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Submit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.indigo.shade900,
                    borderRadius: BorderRadius.circular(10)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
