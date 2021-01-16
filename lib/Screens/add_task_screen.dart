import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../task_data_provider.dart';



class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String newTaskTitle = "";
  final taskNameController = TextEditingController();
  DateTime dT;

  @override
  Widget build(BuildContext context) {
    taskNameController.text = newTaskTitle;
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

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
          selectedDate = picked;


      final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (pickedTime != null)
          selectedTime = pickedTime;

      dT = new DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
          selectedTime.hour, selectedTime.minute);

    }

    return Container(
        color: Color(0xff757575),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Add Task",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.orangeAccent,
                ),
              ),
              TextField(
                // autofocus: true,
                decoration: InputDecoration(hintText: "Enter Task"),
                textAlign: TextAlign.center,
                controller: taskNameController,
                onChanged: (val) {
                  newTaskTitle = val;
                },
                onSubmitted: (val) {
                  newTaskTitle = val;
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                child: RaisedButton.icon(
                  label: Text("Set Deadline"),
                  textColor: Colors.white,
                  icon: Icon(Icons.lock_clock),
                  color: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () => _selectDeadline(context),
                ),
              ),
              dT != null
                  ? Text(
                      "DEADLINE\n${DateFormat("dd MMM HH:mm").format(dT)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    )
                  : SizedBox(),
              FlatButton(
                child: Text(
                  "Add New Task",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.orangeAccent,
                onPressed: () {
                  if(dT==null) dT=DateTime.now();
                  Provider.of<TaskData>(context).add(
                      newTaskTitle,
                      dT.toIso8601String(), //converting DateTime to string to be store in SQLite
                      false);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ));
  }
}
