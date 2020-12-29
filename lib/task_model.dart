import 'db_helper.dart';

class Task{


  String taskName ;
  bool isComplete ;


  Task(this.taskName , this.isComplete);

  Task.fromJson(Map map){
    this.taskName = map[DBHelper.taskNameColumnName] ;
    this.isComplete = map[DBHelper.taskIsCompleteColumnName]== 1 ? true : false ;
  }

  toJson() {
    return {
      DBHelper.taskNameColumnName: this.taskName,
      DBHelper.taskIsCompleteColumnName:this.isComplete ? 1 : 0 
    };
  }
}