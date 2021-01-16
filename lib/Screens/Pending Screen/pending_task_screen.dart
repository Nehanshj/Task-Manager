import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../task_model.dart';
import '../../task_data_provider.dart';
import 'due_time.dart';


class PendingTask extends StatefulWidget {
  @override
  _PendingTaskState createState() => _PendingTaskState();
}

class _PendingTaskState extends State<PendingTask> {
  @override
  void initState() {
    super.initState();
    //loading Pending Tasks
    Provider.of<TaskData>(context, listen: false).getPendingTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Pending Tasks"),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: taskData.pendingTasks.length,
          itemBuilder: (BuildContext context, int index) {
            Task taskInstance = taskData.pendingTasks[index];
            Duration dueTime = DateTime.now()
                .difference(DateTime.tryParse(taskInstance.deadline));
            return ListTile(
              title: Text(taskInstance.taskTitle),
              subtitle: DueTime(dueTime),
              trailing: IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () {
                    Task newTask = Task(
                        id: taskInstance.id,
                        taskTitle: taskInstance.taskTitle,
                        isDone: true,
                        deadline: taskInstance.deadline);
                    taskData.updateTask(newTask);
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("${taskInstance.taskTitle} completed")));
                  }),
            );
          },
        ),
      );
    });
  }
}
