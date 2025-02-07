import 'package:flutter/material.dart';
import 'package:myproject/data/dbHelper.dart';
import 'package:myproject/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreen createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    getNotes();
  }

  void getNotes() async {
    var db = DBHelper.getInstance;
    var result = await db.fetchNotes();
    if(result.isNotEmpty){
       Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>MyApp()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue,
        child: Text(
          "My Notes.",
          style: TextStyle(
              fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
