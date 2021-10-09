import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_managment_app/models/view-all-tasks.dart';

import 'popup-form.dart';

class ViewAllTasksPage extends StatefulWidget {
  @override
  _ViewAllTasksPageState createState() => _ViewAllTasksPageState();
}

fetchAllTasks() async {
  var url = "http://192.168.29.16:3000/tasks";
  SharedPreferences pref = await SharedPreferences.getInstance();
  var storedValue = pref.getString('API_KEY');
  print("API Key is ____________$storedValue");
  var resp = await http
      .get(Uri.parse(url), headers: {"Authorization": "bearer $storedValue"});
  var statusCode = resp.statusCode;
  print("statusCode ___________$statusCode");

  if (statusCode == 200) {
    print("Inside If Condition");
    try {
      var tasks = ViewAllTasks.fromJson(jsonDecode(resp.body));
      print(tasks.toJson());
      return tasks;
    } catch (e) {
      print(e);
    }
    // var tasks = ViewAllTasks.fromJson(jsonDecode(resp.body));
    // print(tasks.toJson());
    // return tasks;
  } else {
    print("NO DATA FOUND________________");
    // return {}.cast<String,dynamic>();
  }
}

class _ViewAllTasksPageState extends State<ViewAllTasksPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController taskName = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController status = new TextEditingController();

  String _initialDropDownValue = "OPEN";

  List<String> dropDownValues = ["OPEN", "INPROGRESS", "CLOSED"];
  String _selectedDropDownValue;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchAllTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print("Inside SNAPSHOT _____");
          print(snapshot.data);
          print(snapshot.data.data);
          var tasks = snapshot.data.data;
          if (snapshot.data.data.length == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.icecream),
                title: Text("No Tasks Found !"),
                selectedTileColor: Colors.blue,
                trailing: Container(
                  // height: 560,
                  width: 50,
                  // color: Colors.red,
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            print(" Update Selected  ");
                          },
                          child: Icon(
                            Icons.update,
                            size: 24,
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                          onTap: () {
                            print("Delete Selected");
                          },
                          child: Icon(Icons.delete))
                    ],
                  ),
                ),
              ),
            );
          } else {
            print(tasks.length);
            return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(
                          Icons.playlist_add_check,
                          size: 30,
                        ),
                        title: Column(children: [Text(tasks[index].name)]),
                        subtitle: Container(
                            child: Column(
                          children: [
                            Text(tasks[index].description),
                            Text("Status :" + tasks[index].status),
                          ],
                        )),
                        selectedTileColor: Colors.blue,
                        trailing: Container(
                          // height: 560,
                          width: 50,
                          // color: Colors.red,
                          child: Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    print(" Update Selected  ");
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Stack(
                                              overflow: Overflow.visible,
                                              children: <Widget>[
                                                Positioned(
                                                  right: -40.0,
                                                  top: -40.0,
                                                  child: InkResponse(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: CircleAvatar(
                                                      child: Icon(Icons.close_rounded),
                                                      backgroundColor: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller: taskName,
                                                          decoration: InputDecoration(
                                                            icon: Icon(Icons.drive_file_rename_outline),
                                                            labelText: 'Name',),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller: description,
                                                          decoration: InputDecoration(
                                                            icon: Icon(Icons.drive_file_rename_outline),
                                                            labelText: 'Description',)
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        EdgeInsets.all(8.0),
                                                        child: DropdownButtonFormField(
                                                          decoration: InputDecoration(
                                                              labelText: "Status",
                                                              // enabledBorder: OutlineInputBorder(
                                                              //     borderSide: BorderSide(
                                                              //       color: Colors.blueAccent.shade200,
                                                              //       width: 2.0,
                                                              //     ))
                                                          ),
                                                          onChanged: (String newValue) {
                                                            setState(() {
                                                              _initialDropDownValue = newValue;
                                                            });
                                                          },
                                                          items:
                                                          dropDownValues.map<DropdownMenuItem<String>>((value) {
                                                            return DropdownMenuItem<String>(
                                                              onTap: () {
                                                                print("Drop down selected"+value);
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
                                                      // )

                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: RaisedButton(
                                                          color: Colors.indigo.shade900,
                                                          child: Text("Update",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                          onPressed: ()async {
                                                            print("Tapped Update Button");
                                                            SharedPreferences pref = await SharedPreferences.getInstance();
                                                            var storedValue = pref.getString('API_KEY');
                                                            // print("API Key is ____________$storedValue");
                                                            var taskId = tasks[index].id.toString();
                                                            var url ='http://192.168.29.16:3000/tasks/${taskId}/tasks';
                                                            print(_selectedDropDownValue);

                                                            var resp = await http.patch(url,
                                                                headers: {
                                                                  "Authorization": "bearer $storedValue"
                                                                },
                                                                body: {
                                                                  "name": taskName.text.toString(),
                                                                  "description": description.text.toString(),
                                                                  "status": _selectedDropDownValue,
                                                                });
                                                            // print(resp);
                                                            // var updateTasks =
                                                            if(resp.statusCode == 200){
                                                              setState(() {
                                                              });
                                                              Navigator. pop(context, false);

                                                            }
                                                            print(resp.statusCode);
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.update,
                                    size: 24,
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    print("Delete Selected");
                                    SharedPreferences pref = await SharedPreferences.getInstance();
                                    var storedValue = pref.getString('API_KEY');
                                    print(
                                        "API Key is ____________$storedValue");
                                    var url =
                                        "http://192.168.29.16:3000/tasks/" +
                                            tasks[index].id.toString();
                                    var resp = await http.delete(
                                      url,
                                      headers: {
                                        "Authorization": "bearer $storedValue"
                                      },
                                    );
                                    setState(() {});

                                    // print(resp.body);
                                  },
                                  child: Icon(Icons.delete))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
          return Container(
              child: ListTile(
            title: Text(tasks[0].name),
          ));
        } else {
          return Center(
            child: Container(
                width: 180,
                child: LinearProgressIndicator(
                  semanticsLabel: "Loading...",
                )),
          );
        }
      },
    );
  }
}
