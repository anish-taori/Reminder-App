import 'package:flutter/material.dart';
import 'package:reminder_app/data/tasks_list.dart';

class CompletedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final completedTaskList = tasksList.where((element) => element.completed==true).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          'Completed Tasks',
          style: TextStyle(
            fontSize: 30,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = Colors.blue[800]!,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemCount: completedTaskList.length,
          itemBuilder: (context,i){
              return ListTile(
                tileColor: Colors.orange,
                title: Row(
                    children: [
                      Text(completedTaskList[i].taskName,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                      Text("     "),
                      Text(completedTaskList[i].taskTime,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                    ]
                ),
              );
          },
          separatorBuilder: (context,i){
            return const Divider(color: Colors.pinkAccent,thickness: 12,);
          },
        ),
      ),
    );
  }
}
