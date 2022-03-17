import 'package:reminder_app/data/tasks_list.dart';

class Task{
  final String taskName;
  final String taskTime;
  bool completed ;

  Task({required this.taskName,required this.taskTime,this.completed=false});
}