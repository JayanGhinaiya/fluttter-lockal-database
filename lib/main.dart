import 'package:flutter/material.dart';
import 'package:flutter_lockaldatabase/database.dart';
import 'package:flutter_lockaldatabase/employ.dart';
import 'package:flutter_lockaldatabase/student.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // home: empolydata(),
      // home: database(),
      home: student(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

    );
  }
}

