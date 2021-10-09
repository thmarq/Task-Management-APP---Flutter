import 'package:flutter/material.dart';
import 'package:task_managment_app/main.dart';

import 'add-taskPage.dart';
import 'view-all-tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Dashboard"),
            backgroundColor: Colors.indigo.shade900,
            leading: Icon(Icons.format_list_bulleted),
            actions: [
              IconButton(
                  icon: Icon(Icons.exit_to_app_sharp),
                  onPressed: ()async {
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    var storedValue = pref.remove('API_KEY');
                    print(storedValue);
                    // Navigator.pop(context,true);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>MyApp()));

                    print("Logout clicked");
                  })
            ],
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.add_chart)),
                Tab(icon: Icon(Icons.view_agenda_outlined)),
                // Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
          ),
          body:  TabBarView(
            children: [
               Container(child: AddTaskPage()),
              // Icon(Icons.directions_car),
              Container(child: ViewAllTasksPage(),),
              // Icon(Icons.directions_transit),
              // Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
