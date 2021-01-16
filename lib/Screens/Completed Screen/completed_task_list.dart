import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../task_model.dart';
import '../../task_data_provider.dart';

class DoneList extends StatefulWidget {
  @override
  _DoneListState createState() => _DoneListState();
}

class _DoneListState extends State<DoneList> {
  @override
  void initState() {
    super.initState();
    //loading Completed Tasks
    Provider.of<TaskData>(context, listen: false).getCompletedTasks();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {//To be updated by ChangeNotifier
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: taskData.completedTasks.length,
            itemBuilder: (BuildContext context, int index) {
              Task taskInstance = taskData.completedTasks[index];
              return DoneTile(taskInstance);
            },
          );
        }

    );
  }
}

class DoneTile extends StatelessWidget {
  DoneTile(this.task);
  final Task task;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Text("Do you want to delete this Task?"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Provider.of<TaskData>(context).deleteCompleted(task.id);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "YES",
                      style: TextStyle(color: Colors.deepOrangeAccent),
                    )),
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "NO",
                      style: TextStyle(color: Colors.deepOrangeAccent),
                    ))
              ],
            ));
        HapticFeedback.vibrate();
      },
      child: ListTile(
        title: Text(task.taskTitle),
        subtitle: Text(DateFormat("dd MMM    HH:mm")
            .format(DateTime.parse(task.deadline))
            .toString()),
        leading: CircleAvatar(child: Icon(Icons.check, color: Colors.white,),backgroundColor: Colors.green,),
        // ),
      ),
    );
  }
}
