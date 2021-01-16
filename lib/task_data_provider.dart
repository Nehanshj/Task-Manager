import 'package:flutter/foundation.dart';
import 'task_model.dart';
import 'database_provider.dart';

class TaskData extends ChangeNotifier {
  List<Task> tasks = [];//Upcoming or Tasks not yet completed
  List<Task> pendingTasks = [];
  List<Task> completedTasks = [];

  void getTasks() async {
    tasks = await TaskDBProvider.db.retrieveTodos();
    notifyListeners();
  }
  void getCompletedTasks() async {
    completedTasks = await TaskDBProvider.db.retrieveDone();
    notifyListeners();
  }
  void getPendingTasks() async {
    pendingTasks = await TaskDBProvider.db.retrievePending();
    notifyListeners();
  }

  void add(String newTaskTitle, String deadline, bool status) {
    TaskDBProvider.db.addTask(newTaskTitle, deadline, status);
    getTasks();//to get updated list of tasks
    notifyListeners();
  }

  void updateTask(Task task) {
    TaskDBProvider.db.updateTask(task);
    getTasks();//to get updated list of tasks
    getPendingTasks();//to get updated list of pending tasks
    notifyListeners();
  }

  void delete(int id) {
    TaskDBProvider.db.delete(id);
    getTasks();
    notifyListeners();
  }

  void deleteCompleted(int id) {
    TaskDBProvider.db.delete(id);
    getCompletedTasks();//to get updated list of completed tasks
    notifyListeners();
  }
}
