class Task {
  int id;
  String taskTitle;
  String deadline;
  bool isDone;

  Task({this.id,this.taskTitle, this.isDone, this.deadline});

  Map<String,dynamic> toMap(){//ID is autoIncrement
    return {
      'task': taskTitle,
      'deadline': deadline,
      'status':isDone==false?0:1,//storing bool as 0/1 in SQL
    };
  }

  factory Task.fromMap(Map<String, dynamic> res) => new Task(
    id:res["id"],
    taskTitle: res["task"],
    deadline: res["deadline"],
    isDone: res["status"]==0?false:true,
  );
}
