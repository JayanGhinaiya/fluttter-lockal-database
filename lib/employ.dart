import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class empolydata extends StatefulWidget {
  const empolydata({Key? key}) : super(key: key);

  @override
  State<empolydata> createState() => _empolydataState();
}

class _empolydataState extends State<empolydata> {
  Box? employ;
  Map<String,dynamic> mapemploy ={};


  Future<List> getemploy() async{
    List lstEmploy =[];
    employ=await Hive.openBox("employ");
    lstEmploy = employ!.values.toList();
    return lstEmploy;
  }
  TextEditingController txtname = TextEditingController();
  TextEditingController txtage = TextEditingController();
  TextEditingController txtsalary =TextEditingController();

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
                          labelText: "Employ name",
                        ),
                      ),
                      TextField(
                        controller: txtage,
                        decoration: InputDecoration(labelText: "Employ age"),
                      ),
                      TextField(
                        controller: txtsalary,
                        decoration: InputDecoration(
                          labelText: "Employ salary.",
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
                      onPressed: ()async {
                        final employHive = await Hive.openBox('employ');
                        employHive.add({'name' : txtname.text,'age' : txtage.text,'salary' : txtsalary.text});
                        setState(() {});
                        print("employ --> ${txtage.text}");
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
                future: getemploy(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData){
                      List employList = snapshot.data!;
                      print('employList.data -> ${employList}');

                 return ListView.builder(
                   itemCount: employList.length,
                      itemBuilder: (BuildContext context, int index) {
                      Map<String,dynamic> mapStudent = Map<String,dynamic>.from(employList[index]);
                      print("mapStudent -->${mapStudent}");
                    return Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mapStudent['name']),
                          Text(mapStudent['age']),
                          Text(mapStudent['salary']),
                        ],
                      ),
                    );
                  });
                } else {
                  return Center(child:Text('You dont have any data'));
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
