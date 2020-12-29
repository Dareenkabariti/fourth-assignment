import 'package:flutter/material.dart';
import 'package:fourth_assignment/db_helper.dart';
import 'package:fourth_assignment/task_model.dart';

class AppProvider extends ChangeNotifier {
  String taskName;
  bool isComplete;

  setValues(String taskName, bool isComplete) {
    var task = Task(taskName, isComplete);
    DBHelper.dbHelper.insertNewTask(task);
    notifyListeners();
  }

  deleteValuesFromDB(String taskName, bool isComplete) {
    var task = Task(taskName, isComplete);
    DBHelper.dbHelper.deleteTask(task);
    notifyListeners();
  }

  Future<List<Task>> getAllValuesFromDB() async {
    var task = Task(taskName, isComplete);
    notifyListeners();
    return await DBHelper.dbHelper.selectAllTasks();
  }

  Future<List<Task>> getSpecificValuesFromDB(int isCom) async {
    // int isCom;
    notifyListeners();
    return await DBHelper.dbHelper.selectSpecificTask(isCom);
  }

  updateValuesFromDB(String taskName, bool isComplete) {
    var task = Task(taskName, isComplete);
    DBHelper.dbHelper.updateTask(task);
    notifyListeners();
  }

  set() {
    notifyListeners();
  }
}
