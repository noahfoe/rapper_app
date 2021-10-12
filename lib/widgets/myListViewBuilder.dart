import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rapper_app/screens/screens.dart';

// Bubble sort function to sort alphabetically
bubbleSort(data, images) {
  print("bubbling");
  int length = data.length;
  String temp = "";
  for (int i = 0; i < length; i++) {
    for (int j = i + 1; j < length; j++) {
      if (data[i].name.compareTo(data[j].name) > 0) {
        temp = data[i].name;
        data[i].name = data[j].name;
        data[j].name = temp;

        temp = data[i].description;
        data[i].description = data[j].description;
        data[j].description = temp;

        temp = data[i].id;
        data[i].id = data[j].id;
        data[j].id = temp;
      }
    }
  }

  //Also sort images
  int length2 = images.length;
  String temp2 = "";
  for (int i = 0; i < length2; i++) {
    for (int j = i + 1; j < length2; j++) {
      if (images[i].compareTo(images[j]) > 0) {
        print("CHANGE");
        temp2 = images[i];
        images[i] = images[j];
        images[j] = temp2;
      }
    }
  }
  //images.sort();
}

// myFuture(data, images) async {
//   print("before");
//   for (int i = 0; i < data.length; i++) {
//     print(images[i] + " " + data[i].name);
//   }

//   print("myFuture");
//   await bubbleSort(data, images);
//   await images.sort();
//   print("after");

// }

class MyListViewBuilder extends StatefulWidget {
  final dynamic data;
  final dynamic images;
  MyListViewBuilder({Key? key, this.data, this.images}) : super(key: key);

  @override
  _MyListViewBuilderState createState() => _MyListViewBuilderState();
}

class _MyListViewBuilderState extends State<MyListViewBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("before");
    for (int i = 0; i < widget.data.length; i++) {
      print(widget.images[i] + " " + widget.data[i].name);
    }

    setState(() {
      bubbleSort(widget.data, widget.images);
    });
    print("after");
    for (int i = 0; i < widget.data.length; i++) {
      print(widget.images[i] + " " + widget.data[i].name);
    }
    return ListView.builder(
      // Count changes based on search bar results
      itemCount: widget.data.length,
      itemBuilder: (BuildContext context, int index) {
        // TODO: Add sorting images alphabetically
        return GestureDetector(
          onTap: () {
            // If user taps on an artist, send them to description page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MySecondPage(
                    // Pass parameters the description page needs
                    desc: widget.data[index].description,
                    name: widget.data[index].name),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            // Card for each artist
            child: Card(
              elevation: 10,
              shadowColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.blue, width: .7),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(0),
                  bottomLeft: const Radius.circular(20),
                  bottomRight: const Radius.circular(20),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Row(
                  children: [
                    const Spacer(flex: 1),
                    // Spacers between text to center it
                    // Display name of each rapper
                    Text(
                      widget.data[index].name,
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(flex: 1),
                    // Display image of each rapper
                    Image.file(
                      File(widget.images[index].toString()),
                      width: 200,
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/*
// ignore: non_constant_identifier_names
Widget MyListViewBuilder(data, images) {
  return FutureBuilder<dynamic>(
      future: myFuture(data, images),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return ListView.builder(
            // Count changes based on search bar results
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              //images.sort();
              // TODO: Add sorting images alphabetically
              // Sort names
              //bubbleSort(data, images);
              //images.sort();
              return GestureDetector(
                onTap: () {
                  // If user taps on an artist, send them to description page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MySecondPage(
                          // Pass parameters the description page needs
                          desc: data[index].description,
                          name: data[index].name),
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  // Card for each artist
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.blue, width: .7),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(0),
                        bottomLeft: const Radius.circular(20),
                        bottomRight: const Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                      child: Row(
                        children: [
                          const Spacer(flex: 1),
                          // Spacers between text to center it
                          // Display name of each rapper
                          Text(
                            data[index].name,
                            style: TextStyle(fontSize: 18),
                          ),
                          const Spacer(flex: 1),
                          // Display image of each rapper
                          Image.file(
                            File(images[index].toString()),
                            width: 200,
                            height: 200,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        else {
          return CircularProgressIndicator();
        }
      });
     
}
 */
