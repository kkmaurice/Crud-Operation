// ignore_for_file: dead_code

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operation/screens/add_task.dart';
import 'package:crud_operation/screens/viewnote.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Color?> myColors = [
    Colors.yellow[200],
    Colors.red[200],
    Colors.green[200],
    Colors.deepPurple[200]
  ];

  @override
  Widget build(BuildContext context) {
    // firebase instance
    CollectionReference ref = FirebaseFirestore.instance.collection('tasks').doc(FirebaseAuth.instance.currentUser!.uid).collection('mytasks');
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async{
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[700],
        child: FutureBuilder<QuerySnapshot>(
          future: ref.get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } 
            
            else if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  Random random = Random();
                  Color? color = myColors[random.nextInt(myColors.length)];

                   Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;


                   DateTime myDate = data['date'].toDate();
                   String formattedDate = DateFormat.yMMMd().add_jm().format(myDate);

                  return  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNote(title: data['name'], description: data['description'], date: formattedDate)));
                    },
                    
                    child: Card(
                      color: color,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${data['name']}',style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),),
                            const SizedBox(height: 10,),
                            
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(formattedDate,style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black
                                  ),
                                  ),),
                                  const Spacer(flex: 1,),
                                   Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: const Icon(Icons.delete,color: Colors.red,),
                                onPressed: ()async {
                                 await ref.doc(snapshot.data!.docs[index].id).delete().then((_) {
                                   setState(() {
                                     // ignore: unnecessary_statements
                                   });
                                 });
                                },
                              ),
                            ),
                              ],
                            ),
                           
                           
                          ]
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              // ignore: sized_box_for_whitespace
              return Container(
                height: 100,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
          

      ),   
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTask()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
    
  }
}