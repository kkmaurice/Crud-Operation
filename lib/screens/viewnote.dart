// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  final String title;
  final String description;
  final String date;

   const ViewNote({Key? key, required this.title, required this.description, required this.date}) : super(key: key);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  CollectionReference<Map<String, dynamic>> ref = FirebaseFirestore.instance.collection('tasks').doc(FirebaseAuth.instance.currentUser!.uid).collection('mytasks');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Text('View', style: TextStyle(color: Colors.cyan[100]),),
            const Text('Note'),
           
          ],
          ),
          centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),),
            const SizedBox(height: 10,),
            Text(widget.description,style: const TextStyle(
              fontSize: 18,
              color: Colors.white70
            ),),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(widget.date,style: const TextStyle(
                fontSize: 15,
                color: Colors.white54
              ),),
            ),
          ]
        ),
      )
    );
  }
}