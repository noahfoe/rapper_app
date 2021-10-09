import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapper_app/services/services.dart';
import 'package:rapper_app/widgets/widgets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        json = allFromJson(data);
        allArtists = json.artists;
        filteredArtists = allArtists;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Search bar is icon inside appbar
      appBar: MyAppBar(),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        // filteredArtists changes based on search
        child: MyListViewBuilder(filteredArtists),
      ),
    );
  }

  // Function that allows users to search for a specific rapper
  void filterByName(String val) {
    setState(() {
      // FilteredArtists is all of the artists whos name contains the value the user types to search for
      filteredArtists = allArtists
          .where((artist) =>
              artist.name.toString().toLowerCase().contains(val.toLowerCase()))
          .toList();
    });
  }

  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    return AppBar(
      // Change title depending on if user is currently searching or not
      title: !isSearching
          ? Text(widget.title)
          : TextField(
              onChanged: (value) {
                // When text is changed, call filter function
                filterByName(value);
              },
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
    );
  }
}
