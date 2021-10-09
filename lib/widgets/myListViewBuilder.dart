import 'package:flutter/material.dart';
import 'package:rapper_app/screens/screens.dart';

// ignore: non_constant_identifier_names
Widget MyListViewBuilder(data) {
  return ListView.builder(
    // Count changes based on search bar results
    itemCount: data.length,
    itemBuilder: (BuildContext context, int index) {
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                Image.network(
                  data[index].image,
                  width: 200,
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
