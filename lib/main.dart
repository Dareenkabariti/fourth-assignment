import 'package:flutter/material.dart';
import 'package:fourth_assignment/app_provider.dart';
import 'package:fourth_assignment/new_task.dart';
import 'package:fourth_assignment/task_model.dart';
import 'package:provider/provider.dart';

import 'db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: TabPage());
  }
}

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return AppProvider();
      },
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                  currentAccountPicture:
                      CircleAvatar(child: Text("D".toUpperCase())),
                  accountName: Text("Assignment3"),
                  accountEmail: Text("Assignment3@gmail.com")),
              ListTile(
                onTap: () {
                  tabController.animateTo(0);
                  Navigator.pop(context);
                },
                title: Text('All Tasks '),
                subtitle: Text('All task data '),
                trailing: Icon(Icons.arrow_right),
              ),
              ListTile(
                onTap: () {
                  tabController.animateTo(1);
                  Navigator.pop(context);
                },
                title: Text('Complete Tasks '),
                subtitle: Text('Complete task data '),
                trailing: Icon(Icons.arrow_right),
              ),
              ListTile(
                onTap: () {
                  tabController.animateTo(2);
                  Navigator.pop(context);
                },
                title: Text('Incomplete Tasks '),
                subtitle: Text(' Incomplete task data '),
                trailing: Icon(Icons.arrow_right),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Todo App'),
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                text: 'All Tasks ',
              ),
              Tab(
                text: 'Complete Tasks',
              ),
              Tab(
                text: 'InComplete Tasks',
              )
            ],
            isScrollable: true,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(controller: tabController, children: [
                _AllTasksState(),
                _CompleteTasksState(),
                _IncompleteTasksState()
              ]),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
            setState(() {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return NewTask();
                },
              ));
            });
          },
        ),
      ),
    );
  }
}

// class AllTasks extends StatefulWidget {
//   @override
//   _AllTasksState createState() => _AllTasksState();
// }

class _AllTasksState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return AppProvider();
      },
      child: Scaffold(
        body: Container(
          child: Consumer<AppProvider>(
            builder: (context, value, child) {
              return FutureBuilder<List<Task>>(
                future: context.watch<AppProvider>().getAllValuesFromDB(),

                // future: DBHelper.dbHelper.selectAllTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Container();
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete_outline),
                              iconSize: 20,
                              color: Colors.blueGrey,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                        child: AlertDialog(
                                      title: Text("Alert Dialog"),
                                      content: Text(
                                          "Are you sure that you want to delete it ??? "),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Delete"),
                                          onPressed: () {
                                            // Task task = Task(
                                            //  ,
                                            //     ;
                                            Task task = Task(
                                                snapshot?.data[index].taskName,
                                                snapshot
                                                    ?.data[index].isComplete);

                                            DBHelper.dbHelper.deleteTask(task);

                                            Navigator.pop(context, false);
                                            context
                                                .read<AppProvider>()
                                                .deleteValuesFromDB(
                                                    snapshot
                                                        ?.data[index].taskName,
                                                    snapshot?.data[index]
                                                        .isComplete);
                                            // setState(() {});
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    ));
                                  },
                                );
                              },
                            ),
                            Text(snapshot?.data[index].taskName),
                            Checkbox(
                                value: snapshot?.data[index].isComplete,
                                onChanged: (value) {
                                  // Task task =
                                  //     Task(snapshot?.data[index].taskName, value);
                                  // DBHelper.dbHelper.updateTask(task);
                                  context
                                      .read<AppProvider>()
                                      .updateValuesFromDB(
                                          snapshot?.data[index].taskName,
                                          value);
                                  snapshot?.data[index].isComplete =
                                      snapshot?.data[index].isComplete;
                                  // setState(() {});
                                }),
                          ],
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
          // child: FutureBuilder<List<Task>>(
          //   future: DBHelper.dbHelper.selectAllTasks(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Container();
          //     } else if (!snapshot.hasData || snapshot.data == null) {
          //       return Container();
          //     } else {
          //       return ListView.builder(
          //         itemCount: snapshot.data.length,
          //         itemBuilder: (context, index) {
          //           return Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               IconButton(
          //                 icon: Icon(Icons.delete_outline),
          //                 iconSize: 20,
          //                 color: Colors.blueGrey,
          //                 onPressed: () {
          //                   showDialog(
          //                     context: context,
          //                     builder: (context) {
          //                       return Center(
          //                           child: AlertDialog(
          //                         title: Text("Alert Dialog"),
          //                         content: Text(
          //                             "Are you sure that you want to delete it ??? "),
          //                         actions: <Widget>[
          //                           FlatButton(
          //                             child: Text("Delete"),
          //                             onPressed: () {
          //                               Task task = Task(
          //                                   snapshot?.data[index].taskName,
          //                                   snapshot?.data[index].isComplete);
          //                               DBHelper.dbHelper.deleteTask(task);
          //                               setState(() {});
          //                               Navigator.pop(context, false);
          //                             },
          //                           ),
          //                           FlatButton(
          //                             child: Text("No"),
          //                             onPressed: () {
          //                               Navigator.pop(context, true);
          //                                },
          //                           ),
          //                         ],
          //                       ));
          //                     },
          //                   );
          //                 },
          //               ),
          //               Text(snapshot?.data[index].taskName),
          //               Checkbox(
          //                   value: snapshot?.data[index].isComplete,
          //                   onChanged: (value) {
          //                     Task task =
          //                         Task(snapshot?.data[index].taskName, value);
          //                     DBHelper.dbHelper.updateTask(task);
          //                     snapshot?.data[index].isComplete =
          //                         snapshot?.data[index].isComplete;
          //                     setState(() {});
          //                   }),
          //             ],
          //           );
          //         },
          //       );
          //     }
          //   },
          // ),
        ),
      ),
    );
  }
}

// class CompleteTasks extends StatefulWidget {
//   @override
//   _CompleteTasksState createState() => _CompleteTasksState();
// }

class _CompleteTasksState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return AppProvider();
      },
      child: Scaffold(
        body: Container(
          child: Consumer<AppProvider>(
            builder: (context, value, child) {
              return FutureBuilder<List<Task>>(
                future: context.watch<AppProvider>().getSpecificValuesFromDB(1),
                // DBHelper.dbHelper.selectSpecificTask(1),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Container();
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete_outline),
                              iconSize: 20,
                              color: Colors.blueGrey,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                        child: AlertDialog(
                                      title: Text("Alert Dialog"),
                                      content: Text(
                                          "You Will Delete A Task , are you sure? "),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("DELETE"),
                                          onPressed: () {
                                            Task task = Task(
                                                snapshot?.data[index].taskName,
                                                snapshot
                                                    ?.data[index].isComplete);
                                            DBHelper.dbHelper.deleteTask(task);
                                            // context
                                            //     .read<AppProvider>()
                                            //     .deleteValuesFromDB(
                                            //         snapshot
                                            //             ?.data[index].taskName,
                                            //         snapshot?.data[index]
                                            //             .isComplete);

                                            // setState(() {});
                                            Navigator.pop(context, false);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    ));
                                  },
                                );
                              },
                            ),
                            Text(snapshot?.data[index].taskName),
                            Checkbox(
                                value: snapshot?.data[index].isComplete,
                                onChanged: (value) {
                                  Task task = Task(
                                      snapshot?.data[index].taskName, value);
                                  context
                                      .read<AppProvider>()
                                      .updateValuesFromDB(
                                          snapshot?.data[index].taskName,
                                          value);

                                  // DBHelper.dbHelper.updateTask(task);
                                  snapshot?.data[index].isComplete =
                                      snapshot?.data[index].isComplete;
                                  // setState(() {});
                                }),
                          ],
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
          // child: FutureBuilder<List<Task>>(
          //   future: DBHelper.dbHelper.selectSpecificTask(1),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Container();
          //     } else if (!snapshot.hasData || snapshot.data == null) {
          //       return Container();
          //     } else {
          //       return ListView.builder(
          //         itemCount: snapshot.data.length,
          //         itemBuilder: (context, index) {
          //           return Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               IconButton(
          //                 icon: Icon(Icons.delete_outline),
          //                 iconSize: 20,
          //                 color: Colors.blueGrey,
          //                 onPressed: () {
          //                   showDialog(
          //                     context: context,
          //                     builder: (context) {
          //                       return Center(
          //                           child: AlertDialog(
          //                         title: Text("Alert Dialog"),
          //                         content: Text(
          //                             "You Will Delete A Task , are you sure? "),
          //                         actions: <Widget>[
          //                           FlatButton(
          //                             child: Text("DELETE"),
          //                             onPressed: () {
          //                               Task task = Task(
          //                                   snapshot?.data[index].taskName,
          //                                   snapshot?.data[index].isComplete);
          //                               DBHelper.dbHelper.deleteTask(task);
          //                               setState(() {});
          //                               Navigator.pop(context, false);
          //                             },
          //                           ),
          //                           FlatButton(
          //                             child: Text("No"),
          //                             onPressed: () {
          //                               Navigator.pop(context, true);
          //                             },
          //                           ),
          //                         ],
          //                       ));
          //                     },
          //                   );
          //                 },
          //               ),
          //               Text(snapshot?.data[index].taskName),
          //               Checkbox(
          //                   value: snapshot?.data[index].isComplete,
          //                   onChanged: (value) {
          //                     Task task =
          //                         Task(snapshot?.data[index].taskName, value);
          //                     DBHelper.dbHelper.updateTask(task);
          //                     snapshot?.data[index].isComplete =
          //                         snapshot?.data[index].isComplete;
          //                     setState(() {});
          //                   }),
          //             ],
          //           );
          //         },
          //       );
          //     }
          //   },
          // ),
        ),
      ),
    );
  }
}

// class IncompleteTasks extends StatefulWidget {
//   @override
//   _IncompleteTasksState createState() => _IncompleteTasksState();
// }

class _IncompleteTasksState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return AppProvider();
      },
      child: Scaffold(
        body: Container(
          child: Consumer<AppProvider>(
            builder: (context, value, child) {
              return FutureBuilder<List<Task>>(
                future: context.watch<AppProvider>().getSpecificValuesFromDB(0),

                // future: DBHelper.dbHelper.selectSpecificTask(0),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Container();
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete_outline),
                              iconSize: 20,
                              color: Colors.blueGrey,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                        child: AlertDialog(
                                      title: Text("Alert Dialog"),
                                      content: Text(
                                          "You Will Delete A Task , are you sure? "),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("DELETE"),
                                          onPressed: () {
                                            Task task = Task(
                                                snapshot?.data[index].taskName,
                                                snapshot
                                                    ?.data[index].isComplete);
                                            DBHelper.dbHelper.deleteTask(task);
                                            // context
                                            //     .read<AppProvider>()
                                            //     .deleteValuesFromDB(
                                            //         snapshot
                                            //             ?.data[index].taskName,
                                            //         snapshot?.data[index]
                                            //             .isComplete);
                                            // setState(() {});
                                            Navigator.pop(context, false);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    ));
                                  },
                                );
                              },
                            ),
                            Text(snapshot?.data[index].taskName),
                            Checkbox(
                                value: snapshot?.data[index].isComplete,
                                onChanged: (value) {
                                  Task task = Task(
                                      snapshot?.data[index].taskName, value);
                                  context
                                      .read<AppProvider>()
                                      .updateValuesFromDB(
                                          snapshot?.data[index].taskName,
                                          value);

                                  // DBHelper.dbHelper.updateTask(task);
                                  snapshot?.data[index].isComplete =
                                      snapshot?.data[index].isComplete;
                                  // setState(() {});
                                }),
                          ],
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
          // child: FutureBuilder<List<Task>>(
          //   future: DBHelper.dbHelper.selectSpecificTask(0),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Container();
          //     } else if (!snapshot.hasData || snapshot.data == null) {
          //       return Container();
          //     } else {
          //       return ListView.builder(
          //         itemCount: snapshot.data.length,
          //         itemBuilder: (context, index) {
          //           return Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               IconButton(
          //                 icon: Icon(Icons.delete_outline),
          //                 iconSize: 20,
          //                 color: Colors.blueGrey,
          //                 onPressed: () {
          //                   showDialog(
          //                     context: context,
          //                     builder: (context) {
          //                       return Center(
          //                           child: AlertDialog(
          //                         title: Text("Alert Dialog"),
          //                         content: Text(
          //                             "You Will Delete A Task , are you sure? "),
          //                         actions: <Widget>[
          //                           FlatButton(
          //                             child: Text("DELETE"),
          //                             onPressed: () {
          //                               Task task = Task(
          //                                   snapshot?.data[index].taskName,
          //                                   snapshot?.data[index].isComplete);
          //                               DBHelper.dbHelper.deleteTask(task);
          //                               setState(() {});
          //                               Navigator.pop(context, false);
          //                             },
          //                           ),
          //                           FlatButton(
          //                             child: Text("No"),
          //                             onPressed: () {
          //                               Navigator.pop(context, true);
          //                             },
          //                           ),
          //                         ],
          //                       ));
          //                     },
          //                   );
          //                 },
          //               ),
          //               Text(snapshot?.data[index].taskName),
          //               Checkbox(
          //                   value: snapshot?.data[index].isComplete,
          //                   onChanged: (value) {
          //                     Task task =
          //                         Task(snapshot?.data[index].taskName, value);
          //                     DBHelper.dbHelper.updateTask(task);
          //                     snapshot?.data[index].isComplete =
          //                         snapshot?.data[index].isComplete;
          //                     setState(() {});
          //                   }),
          //             ],
          //           );
          //         },
          //       );
          //     }
          //   },
          // ),
        ),
      ),
    );
  }
}
