import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../task_model.dart';
import '../task_data_provider.dart';
import 'package:intl/intl.dart';


class EditDialog extends StatefulWidget {
  EditDialog(this.task);
  final Task task;

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  TextEditingController tasktitle = new TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  DateTime dT;
  DateTime newDt;

  _selectDeadline(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate, // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        selectableDayPredicate: (date) {
          if (date.isAfter(DateTime.now().subtract(Duration(days: 1))))
            return true;
          return false;
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });

    final TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null)
      setState(() {
        selectedTime = pickedTime;
      });

    setState(() {
      newDt = new DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    tasktitle.text = widget.task.taskTitle;
    dT = DateTime.tryParse(widget.task.deadline);

    var taskData = Provider.of<TaskData>(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      contentPadding: EdgeInsets.all(12),
      content: Container(
        height: 0.5*MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Text(
              "Edit Task",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w500,
                fontSize: 0.06 * MediaQuery.of(context).size.width,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(
              thickness: 1,
              color: Colors.orange,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Task Name",
                border: OutlineInputBorder(),
                fillColor: Colors.orangeAccent,
                focusColor: Colors.white,
              ),
              controller: tasktitle,
              onChanged: (val) {
                widget.task.taskTitle = val;
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text("Deadline: ${DateFormat("dd MMM HH:mm").format(dT)}"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RaisedButton.icon(
                  label: Text("Change Deadline"),
                  textColor: Colors.white,
                  icon: Icon(Icons.lock_clock),
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    _selectDeadline(context);
                    setState(() {});
                  }),
            ),
            newDt != null
                ? Text(
              "New Deadline\n ${DateFormat("dd MMM HH:mm").format(newDt)}",
              textAlign: TextAlign.center,
            )
                : SizedBox(),
            RaisedButton(
                child: Text(
                  "SAVE",
                  style: TextStyle(color: Colors.deepOrange),
                ),
                onPressed: () {
                  if(newDt==null)
                    newDt=dT;
                  Task task = Task(
                    id: widget.task.id,
                    taskTitle: tasktitle.text,
                    deadline: newDt.toIso8601String(),
                    isDone: widget.task.isDone,
                  );
                  taskData.updateTask(task);
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
    );
  }
}