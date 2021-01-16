import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Screens/Upcoming%20Screen/task_tile.dart';
import '../../task_model.dart';
import '../../task_data_provider.dart';
import '../add_task_screen.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
    //loading Tasks
    Provider.of<TaskData>(context, listen: false).getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => SingleChildScrollView(
                  child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddTaskScreen(),
              )),
              isScrollControlled: true,
            );
          },
          child: Icon(Icons.add,color: Colors.white,),
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: taskData.tasks.length,
          itemBuilder: (BuildContext context, int index) {
            Task taskInstance = taskData.tasks[index];
            return TaskTile(task: taskInstance);
          },
        ),
      );
    });
  }
}


