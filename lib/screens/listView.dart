import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapper_app/rapper.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:rapper_app/screens/descView.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String rapperData = "";
  late List allArtists = [];
  late List<dynamic> filteredArtists = [];
  late Json json;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initilize and parse data from http response
    fetchData().then((data) {
      setState(() {
        rapperData = data;
        json = allFromJson(rapperData);
        allArtists = json.artists;
        filteredArtists = allArtists;
      });
    });
    //rapperData = fetchData();
  }

  // fetchData function to gather data of the rappers from the URL
  Future<String> fetchData() async {
    final response = await http.get(
      Uri.parse(
        'http://assets.aloompa.com.s3.amazonaws.com/rappers/rappers.json',
      ),
    );

    // Response code 200 means OK, so we parse the data
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // Throw exception if not OK
      throw Exception('Error: No data found.');
    }
  }

  // Function that allows users to search for a specific rapper
  void filterByName(String val) {
    setState(() {
      filteredArtists = allArtists
          .where((artist) =>
              artist.name.toString().toLowerCase().contains(val.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Search bar is icon inside appbar
      appBar: AppBar(
        // Change title depending on if user is currently searching or not
        title: !isSearching
            ? Text(widget.title)
            : TextField(
                onChanged: (value) {
                  filterByName(value);
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Search Rapper Here",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        // Change icons depeding on if user is searching or not
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      // filteredArtists should contain all artists if the user taps on cancel icon
                      filteredArtists = allArtists;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        // filteredArtists changes based on search
        child: ListView.builder(
          itemCount: filteredArtists.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                // If user taps on an artist, send them to description page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MySecondPage(
                        desc: filteredArtists[index].description,
                        name: filteredArtists[index].name),
                  ),
                );
              },
              // Card for each artist
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Row(
                    children: [
                      Spacer(flex: 1),
                      Text(
                        filteredArtists[index].name,
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(flex: 1),
                      Image.network(
                        filteredArtists[index].image,
                        width: 200,
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
