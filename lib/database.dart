import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class database extends StatefulWidget {
  const database({Key? key}) : super(key: key);

  @override
  State<database> createState() => _databaseState();
}

class _databaseState extends State<database> {
  Box? student;
  Map<String, dynamic> mapstudent = {};


  ///Get data from local database
  Future<List> getstudent() async {
    List lstStudents = [];
    student = await Hive.openBox("student");
    lstStudents = student!.values.toList();
    // print('student -> ${lstStudents}');
    return lstStudents;
  }

  TextEditingController txtname = TextEditingController();
  TextEditingController txtage = TextEditingController();
  TextEditingController txtmo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  // color: Colors.yellow,
                  width: 350,
                  child: Column(
                    children: [
                      TextField(
                        controller: txtname,
                        decoration: InputDecoration(
                          labelText: "Name",
                        ),
                      ),
                      TextField(
                        controller: txtage,
                        decoration: InputDecoration(labelText: "Age"),
                      ),
                      TextField(
                        controller: txtmo,
                        decoration: InputDecoration(
                          labelText: "Mo.",
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  height: 60,
                  width: 100,
                  child: ElevatedButton(
                      onPressed: () async {
                        ///Add to local database
                        final studHive = await Hive.openBox('student');
                        studHive.add({
                          'name': txtname.text,
                          'age': txtage.text,
                          'mobile': txtmo.text
                        });
                        setState(() {});
                      },
                      child: Text("Add")),
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.black,
          ),
          Expanded(
              child: FutureBuilder<List>(
               future: getstudent(),
               builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List studList = snapshot.data!;
                  print('snapshot.data -> ${studList[0]['name']}');
                  // List lstStudent = json.decode(lstStudent1).cast<String>().toList();
                  return ListView.builder(
                      itemCount: studList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> mapStudent =
                            Map<String, dynamic>.from(studList[index]);
                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mapStudent['name']),
                              Text(mapStudent['age']),
                              Text(mapStudent['mobile']),
                            ],
                          ),
                        );
                      });
                } else {
                  return Center(
                    child: Text('You dont have any data'),
                  );
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          ))
        ],
      ),
    );
  }
}
