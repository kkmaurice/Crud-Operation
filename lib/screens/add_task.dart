// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AddTask extends StatefulWidget {
  const AddTask({ Key? key }) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

String? taskName;
String? taskDescription;
// send it to the database
addTaskToFirebase()async{
  try{
    CollectionReference ref = FirebaseFirestore.instance.collection('tasks').doc(FirebaseAuth.instance.currentUser!.uid).collection('mytasks');

    var task = {
      'name': taskName,
      'description': taskDescription,
      'date': DateTime.now(),
      'completed': false,
    };
    await ref.add(task);
    Navigator.pop(context);
  }catch(e){
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        centerTitle: true,
        backgroundColor: Colors.cyan[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                child: TextField(
                  onChanged: (value){
                    taskName=value;
                  },
                  //controller: titleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Title',
                  ),
                  
                ),
              ),
              const SizedBox(height: 16.0),
               TextField(
                 onChanged: (value){
                   taskDescription=value;
                 },
                //controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Description',
                ),
              ),

              const SizedBox(height: 16.0),
              

              Container(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  child: const Text('Add Task'),
                  onPressed: () {
                    addTaskToFirebase();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.pressed) ? Colors.green : Colors.purple),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}