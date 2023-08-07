import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ToDoDatabase {
  List todoList = [];
  List imageList = [];

  final _myBox = Hive.box('mynotes');
  final _imageBox = Hive.box('images');

  // initial data
  void createInitialData() {
    todoList = [
      [
        "Welcome to ToDo App",
        false,
        DateTime.now().millisecondsSinceEpoch,
        "9:30",
      ],
      [
        "Feel free to explore",
        false,
        DateTime.now().millisecondsSinceEpoch,
        "10:30",
      ],
    ];
  }

  void createInitialImage() {
    imageList = [Image.asset('assets/images/avatar.jpg')];
  }

  void loadData() {
    todoList = _myBox.get("TODOLIST");
  }

  void loadImageData() {
    imageList = _imageBox.get("imagelist");
  }

  void updateImageDb() {
    _imageBox.put("imagelist", imageList);
  }

  void updateDatabase() {
    _myBox.put("TODOLIST", todoList);
  }
}
