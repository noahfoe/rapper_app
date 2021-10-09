import 'package:flutter/material.dart';

class MySecondPage extends StatelessWidget {
  final String desc;
  final String name;
  const MySecondPage({Key? key, required this.desc, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$name" + "'s Description"),
      ),
      body: Center(
        child: Card(
          elevation: 10,
          shadowColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue, width: .7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "$desc",
              style: TextStyle(fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }
}
