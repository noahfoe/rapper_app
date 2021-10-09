import 'package:flutter/material.dart';
import 'package:rapper_app/screens/descView.dart';

class MyGestureDetector extends StatelessWidget {
  final String name;
  final String image;
  final String desc;

  const MyGestureDetector(
      {Key? key, required this.name, required this.image, required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to description page
        print("Tapped $name");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MySecondPage(desc: desc, name: name),
          ), // Maybe use ID here?
        );
      },
      child: Container(
        child: Row(
          children: [
            Spacer(flex: 1),
            Text("$name"),
            Spacer(flex: 1),
            Image.network(
              '$image',
              width: 150,
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
