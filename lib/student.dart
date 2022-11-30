import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class student extends StatefulWidget {
  const student({Key? key}) : super(key: key);

  @override
  State<student> createState() => _studentState();
}

class _studentState extends State<student> {
  Box? student;
  Map<String,dynamic> mapstudent = {};
  bool isupadate = false;
  int selectedindex = 0;

  edit(String txtstd,String txtclass,String txtid,String txtcity,int index){
    student?.putAt(index,{'standard': txtstd,'class' : txtclass,'id' : txtid,'city' : txtcity});
  }


  Future<List> getstudent() async{
  List lstStudents = [];
  student = await Hive.openBox("student");
  lstStudents = student!.values.toList();
  print('student --> ${lstStudents}');
  return lstStudents;
  }

  delete(int index){
    student?.deleteAt(index);
  }

  TextEditingController txtstd = TextEditingController();
  TextEditingController txtclass = TextEditingController();
  TextEditingController txtid = TextEditingController();
  TextEditingController txtcity = TextEditingController();
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
                         controller: txtstd,
                          textInputAction:TextInputAction.next ,
                        decoration: InputDecoration(
                          labelText: "Student Standard",
                        ),
                      ),
                      TextField(
                        textInputAction: TextInputAction.next,
                        controller: txtclass,
                        decoration: InputDecoration(labelText: "Student Class"),
                      ),
                      TextField(
                        controller: txtid,
                        textInputAction:TextInputAction.next ,
                        decoration: InputDecoration(
                          labelText: "Student Id",
                        ),
                      ),
                      TextField(
                        controller: txtcity,
                        textInputAction:TextInputAction.next ,
                        decoration: InputDecoration(
                          labelText: "Student City",
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
                      onPressed: () async{
                        final studHive = await Hive.openBox('student');
                        if(isupadate == true){
                          edit(txtstd.text, txtclass.text, txtid.text, txtcity.text, selectedindex);
                        }else{
                          studHive.add({
                          'standard': txtstd.text,
                          'class' : txtclass.text,
                          'id' : txtid.text,
                          'city' : txtcity.text,
                        });
                        }

                        setState(() {});
                      },
                      child: Text(isupadate == true ?"upadate" : "Add")),
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
              child:  FutureBuilder<List>(
                future: getstudent(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.active ||
                   snapshot.connectionState == ConnectionState.done){
                    if (snapshot.hasData){
                      List studentList = snapshot.data!;
                      print('snapshoat -> ${studentList}');
                      print('studentList.length -> ${studentList.length}');
                return ListView.builder(
                  itemCount:studentList.length ,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String,dynamic> mapstudent =
                          Map<String,dynamic>.from(studentList[index]);
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mapstudent['standard']),
                            Text(mapstudent['class']),
                            Text(mapstudent['id']),
                            Text(mapstudent['city']),
                            IconButton(onPressed: (){
                              isupadate = true;
                              txtstd.text = mapstudent['standard'];
                              txtclass.text = mapstudent['class'];
                              txtid.text = mapstudent['id'];
                              txtcity.text = mapstudent['city'];
                              selectedindex = index;
                              setState(() {
                              });
                            }, icon:Icon(Icons.edit)),
                            IconButton(onPressed: (){
                              delete(index);
                              setState(() {

                              });
                            }, icon:Icon(Icons.delete))
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
              )
          )
        ],
      ),
    );
  }
}
