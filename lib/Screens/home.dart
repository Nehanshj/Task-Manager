import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../database_provider.dart';

import 'Completed Screen/completed_task_list.dart';
import 'Pending Screen/pending_task_screen.dart';
import 'Upcoming Screen/upcoming_task_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    TaskDBProvider.db.database;//Initialzing the Database
    super.initState();
    initScreen();
  }

  ///Dialog Box on App Startup
  initScreen() async {
    List values = await TaskDBProvider.db.getCount();//Count of All and Completed Tasks
    var time = DateTime.now();
    String timeOfDay;

    //Deciding Time of the DAy
    if (time.hour > 6 && time.hour < 10)
      timeOfDay = "Morning";
    else if (time.hour > 10 && time.hour < 1)
      timeOfDay = "Noon";
    else if (time.hour > 1 && time.hour < 5)
      timeOfDay = "AfterNoon";
    else
      timeOfDay = "Evening";

    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.deepOrangeAccent),
                    ))
              ],
              content: Container(
                height: 0.5 * MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Text(
                      "Good $timeOfDay",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: Colors.deepOrangeAccent),
                    ),
                    values[0]!=0?//Radial Gauge not shown if 0 tasks in DB
                    Expanded(
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  positionFactor: 0.1,
                                  angle: 90,
                                  widget: Text(
                                    values[1].toString() +
                                        ' / ' +
                                        values[0].toString() +
                                        "\nTASKS COMPLETED",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ))
                            ],
                            pointers: <GaugePointer>[
                              RangePointer(
                                color: Colors.deepOrangeAccent,
                                value: values[1].toDouble(),
                                cornerStyle: CornerStyle.bothCurve,
                                width: 0.2,
                                sizeUnit: GaugeSizeUnit.factor,
                              )
                            ],
                            minimum: 0,
                            maximum: values[0].toDouble(),
                            showLabels: false,
                            showTicks: false,
                            axisLineStyle: AxisLineStyle(
                              thickness: 0.2,
                              cornerStyle: CornerStyle.bothCurve,
                              color: Colors.deepOrangeAccent.shade100,
                              thicknessUnit: GaugeSizeUnit.factor,
                            ),
                          )
                        ],
                      ),
                    ):Text("Welcome OnBoard", style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Colors.deepOrangeAccent),)
                  ],
                ),
              ),
            ));
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.error_outline_outlined),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PendingTask())),
              )
            ],
            bottom: TabBar(
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 6.0, color: Colors.white),
                  insets: EdgeInsets.symmetric(horizontal: 16.0)),
              unselectedLabelColor: Colors.orangeAccent,
              indicatorColor: Colors.orange,
              tabs: [
                Tab(text: "Upcoming"),
                Tab(text: "Completed"),
              ],
            ),
            title: Text('Task Manager'),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          body: TabBarView(
            children: [
              TaskList(),//Showing all upcoming tasks
              DoneList(),//Showing all completed tasks
            ],
          ),
        ));
  }
}
