import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../database_provider.dart';
import '../../task_model.dart';
import '../../task_data_provider.dart';
import '../edit_dialog.dart';

class TaskTile extends StatefulWidget {
  TaskTile({@required this.task});
  final Task task;

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    var checkPending = DateTime.tryParse(widget.task.deadline).isBefore(DateTime.now());

    return GestureDetector(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Text("Do you want to delete this Task?"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Provider.of<TaskData>(context).delete(widget.task.id);
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
        HapticFeedback.vibrate();//Haptic feedback on long press to delete
      },
      child: Dismissible(
        key: Key(widget.task.taskTitle),
        background: Container(//used for Edit
          color: Colors.blueGrey,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                )),
          ),
        ),
        secondaryBackground: Container(//used for Mark as Done
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                )),
          ),
        ),
        confirmDismiss: (direction) {
          if (direction == DismissDirection.startToEnd) {
            showDialog(
                context: context,
                builder: (context) => EditDialog(widget.task));//Show Edit Dialog from Left to right swipe
            return Future.value(false);
          }
          return Future.value(direction == DismissDirection.endToStart);
        },
        onDismissed: (direction) {//Mark as Done on right to left swipe
          Task taskDone = Task(
              id: widget.task.id,
              taskTitle: widget.task.taskTitle,
              isDone: true,
              deadline: widget.task.deadline);
          TaskDBProvider.db.done(taskDone);
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Task: ${widget.task.taskTitle} completed")));
        },
        child: ListTile(
          title: Text(widget.task.taskTitle),
          subtitle: Text(DateFormat("dd MMM    HH:mm")
              .format(DateTime.parse(widget.task.deadline))
              .toString()),
          leading: Icon(
            checkPending ? Icons.error_outline_outlined : Icons.file_copy,
            color: checkPending ? Colors.red : Colors.orangeAccent,
            size: 37,
          ),
        ),
      ),
    );
  }
}