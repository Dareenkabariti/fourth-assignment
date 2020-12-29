import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourth_assignment/app_provider.dart';
import 'package:fourth_assignment/task_model.dart';
import 'package:provider/provider.dart';

import 'db_helper.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  bool isComplete = false;
  String taskName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return AppProvider();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Task'),
        ),
        body: Container(
          child: Consumer<AppProvider>(
            builder: (context, value, child) {
              return Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey)),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "enter name ...",
                        ),
                        onChanged: (value) {
                          this.taskName = value;
                        },
                      ),
                    ),
                    CheckboxListTile(
                      title: Text(" Complete "),
                      value: isComplete,
                      onChanged: (value) {
                        this.isComplete = value;
                        setState(() {});
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
                      child: Text(
                        'add',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        Task task = Task(this.taskName, this.isComplete);
                        // setState(() {
                        context
                            .read<AppProvider>()
                            .setValues(this.taskName, this.isComplete);

                        // DBHelper.dbHelper.insertNewTask(task);
                        //}
                        // );
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
        // body: Container(
        //   padding: EdgeInsets.all(20),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(5),
        //             border: Border.all(color: Colors.grey)),
        //         child: TextField(
        //           decoration: InputDecoration(
        //             border: InputBorder.none,
        //             labelText: "enter name ...",
        //           ),
        //           onChanged: (value) {
        //             this.taskName = value;
        //           },
        //         ),
        //       ),
        //       CheckboxListTile(
        //         title: Text(" Complete "),
        //         value: isComplete,
        //         onChanged: (value) {
        //           this.isComplete = value;
        //           setState(() {});
        //         },
        //         controlAffinity: ListTileControlAffinity.leading,
        //       ),
        //       RaisedButton(
        //         padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
        //         child: Text(
        //           'add',
        //           style: TextStyle(color: Colors.white, fontSize: 20),
        //         ),
        //         color: Colors.blue,
        //         onPressed: () {
        //           Task task = Task(this.taskName, this.isComplete);
        //           setState(() {
        //             DBHelper.dbHelper.insertNewTask(task);
        //           });
        //           Navigator.pop(context);
        //         },
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
