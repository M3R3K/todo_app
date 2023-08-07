import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/database/database.dart';
import 'package:todo_app/widgets/todo_item.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // title dates
  final DateTime today = DateTime.now();
  final DateFormat format = DateFormat('MMMM');

  // hive
  final myBox = Hive.box('mynotes');
  final imagebox = Hive.box('images');
  // databaase initialize
  ToDoDatabase db = ToDoDatabase();

  TimeOfDay timeOfDay = TimeOfDay.now();

  // snackbar
  final snackBar = SnackBar(
    content: Text('You can\'t add a blank task!'),
  );

  final _todoController = TextEditingController();

  Future<String?> displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: timeOfDay,
    );
    if (time != null) {
      return "${time.hour}:${time.minute}";
    } else {
      return null;
    }
  }

  Future openDialog(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Center(
              child: Text("Add a task"),
            ),
            actions: [
              TextField(
                controller: _todoController,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      String? time = await displayTimePicker(context);
                      if (time == null) {
                        Navigator.pop(context);
                      } else {
                        addToDoItem(_todoController.text, time);
                        Navigator.pop(context, 'OK');
                      }
                    },
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {
                      _todoController.clear();
                      Navigator.pop(context, 'Cancel');
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              )
            ],
          ));

  void addToDoItem(String todo, String time) {
    if (todo != "") {
      setState(() {
        db.todoList
            .add([todo, false, DateTime.now().millisecondsSinceEpoch, time]);
        db.updateDatabase();
      });
      _todoController.clear();
    } else {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
    }
  }

  void deleteToDoItem(int key) {
    setState(() {
      db.todoList.removeWhere((element) => element[2] == key);
      db.updateDatabase();
    });
  }

  void editItem(int key, String newText, String time) {
    setState(() {
      db.todoList.where((element) => element[2] == key).toList().first[0] =
          newText;
      if (time.isNotEmpty) {
        db.todoList.where((element) => element[2] == key).toList().first[3] =
            time;
      }
      db.updateDatabase();
    });
  }

  void changeState(int key) {
    setState(() {
      int index = db.todoList.indexWhere((element) => element[2] == key);
      db.todoList[index][1] = !db.todoList[index][1];
      db.updateDatabase();
    });
  }

  @override
  void initState() {
    if (myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog(context);
        },
        child: Icon(Icons.add_box),
      ),
      backgroundColor: tdBGColor,
      appBar: AppBar(
        elevation: 8,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "TODAY",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  format.format(today) + " " + today.day.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      textBaseline: TextBaseline.alphabetic),
                ),
              ],
            ),
            Text("A"),
          ],
        ),
        backgroundColor: tdBGColor,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      for (int i = db.todoList.length - 1; i >= 0; i--)
                        ToDoItem(
                          taskName: db.todoList[i][0],
                          isDone: db.todoList[i][1],
                          uniqueKey: db.todoList[i][2],
                          onChanged: changeState,
                          onDelete: deleteToDoItem,
                          onEdit: editItem,
                          time: db.todoList[i][3],
                          myController:
                              TextEditingController(text: db.todoList[i][0]),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
