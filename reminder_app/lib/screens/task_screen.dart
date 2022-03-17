import 'package:flutter/material.dart';
import 'package:reminder_app/models/task.dart';
import 'package:reminder_app/data/tasks_list.dart';
import 'package:reminder_app/screens/completed_tasks_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TasksScreen extends StatefulWidget {

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  var _isInit = true;
  @override
  void dispose() {
    myController.dispose();
    myController2.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    if(_isInit){
      final url = Uri.parse('https://reminders-app-9fa68-default-rtdb.firebaseio.com/tasks.json');
      http.get(url).then(
              (response){
            final decodedData = json.decode(response.body) as Map<String,dynamic>;
            decodedData.forEach((key, value) {
              tasksList.add(Task(taskName: value['Task Name'], taskTime: value['Task Time']));
            });
          });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          'My Tasks',
          style: TextStyle(
            fontSize: 30,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2
              ..color = Colors.blue[800]!,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              final String time;
              final String taskName;
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 320,
                      color: Colors.pinkAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text(
                              'Please enter a new task',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.yellowAccent
                              ),
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Task Name',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.yellowAccent,
                                ),
                              ),
                              controller: myController,
                            ),
                            TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Time',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.yellowAccent,
                                ),
                              ),
                              controller: myController2,
                            ),
                            ElevatedButton(
                              child: const Text('Add'),
                              onPressed: (){
                                setState(() {
                                  Task newTask = Task(taskName: myController.text,taskTime: myController2.text);
                                  tasksList.add(newTask);
                                  final url = Uri.parse('https://reminders-app-9fa68-default-rtdb.firebaseio.com/tasks.json');
                                  http.post(
                                      url,
                                      body: json.encode({
                                        'Task Name' : newTask.taskName,
                                        'Task Time' : newTask.taskTime,
                                      })
                                  );
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            itemBuilder: (BuildContext context,int i){
              Task newTask = tasksList[i];
              return ListTile(
                title: Row(
                  children: [
                    Text(newTask.taskName,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                    const Text("     "),
                    Text(newTask.taskTime,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  ]
                ),
                leading: Checkbox(
                  value: newTask.completed,
                  onChanged: (bool? value) {
                    setState(() {
                      newTask.completed = value!;
                    });
                    if(value == true){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CompletedTasksScreen()),
                      );
                    }
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: (){
                        showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 320,
                                color: Colors.pinkAccent,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text(
                                        'Please edit the task',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.yellowAccent
                                        ),
                                      ),
                                      TextField(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Task Name',
                                          labelStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.yellowAccent,
                                          ),
                                        ),
                                        controller: myController,
                                      ),
                                      TextField(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Time',
                                          labelStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.yellowAccent,
                                          ),
                                        ),
                                        controller: myController2,
                                      ),
                                      ElevatedButton(
                                        child: const Text('Edit'),
                                        onPressed: (){
                                          setState(() {
                                            Task editedTask = Task(taskName: myController.text,taskTime: myController2.text);
                                            tasksList.add(editedTask);
                                            tasksList.remove(newTask);
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );

                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        setState(() {
                          tasksList.remove(newTask);
                        });
                      },
                    ),
                  ],
                ),
                tileColor: Colors.orange,
              );
            },
          itemCount: tasksList.length,
          separatorBuilder: (context, index) {
            return const Divider(color: Colors.pinkAccent,thickness: 12,);
          },

        ),
      ),
    );
  }
}


