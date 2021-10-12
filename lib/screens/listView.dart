import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rapper_app/services/services.dart';
import 'package:rapper_app/services/rapper.dart';
import 'package:rapper_app/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List allArtists = [];
  late List<dynamic> filteredArtists = [];
  List<String> listOfImgStrings = [];
  List<String> filteredListOfImgStrings = [];
  String? filePath;
  late Json json;
  bool isSearching = false;
  File? jsonFile;
  Directory? dir;
  String fileName = "data.json";
  bool fileExists = false;
  Map<String, dynamic>? fileContent;
  late String fileContentString;

  @override
  void initState() {
    super.initState();
    // Check if we have already called api and saved the data from it
    getFileExistsSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    setFileExistsSharedPref(fileExists);
    return Scaffold(
      // Search bar is icon inside appbar
      appBar: MyAppBar(),
      body: Container(
        // filteredArtists changes based on search
        child: MyListViewBuilder(filteredArtists, filteredListOfImgStrings),
      ),
    );
  }

  // Function to setup the directory and file for cached json file
  void setupFile() async {
    // Get file directory and create file
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir!.path + "/" + fileName);
      fileExists = jsonFile!.existsSync();
      if (fileExists)
        this.setState(() {
          fileContent = jsonDecode(jsonFile!.readAsStringSync());
          var encoded = jsonEncode(fileContent);
          saveFile(encoded);
          writeFile(encoded);
        });
    });
    // If the cached file does not exist
    if (!fileExists) {
      // Initilize and parse data from http response
      fetchData().then((data) {
        setState(() {
          saveFile(data);
          writeFile(data);
          json = allFromJson(data);
          allArtists = json.artists;
          filteredArtists = allArtists;
          getImageDirList(allArtists);
        });
      });
    } else {
      // File does exist, so use that file
      json = allFromJson(fileContentString);
      allArtists = json.artists;
      filteredArtists = allArtists;
      getImageDirList(allArtists);
    }
  }

  // Function to call http GET request on images, in order to store them in cache
  getImageDirList(List<dynamic> artists) async {
    artists.forEach((artist) async {
      var response = await http.get(Uri.parse(artist.image));
      Directory docDir = await getApplicationDocumentsDirectory();
      File file = new File(join(docDir.path, '${artist.name}.jpeg'));
      file.writeAsBytesSync(response.bodyBytes);
      if (!listOfImgStrings.contains(file.path))
        listOfImgStrings.add(file.path);
      setState(() {});
      saveImages(listOfImgStrings);
    });
    setState(() {
      filteredListOfImgStrings = listOfImgStrings;
    });
  }

  // Function sets the value of fileExists in the cache
  void saveImages(List<String> images) async {
    images.sort();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('image', images);
  }

  // Function changes value of fileExists bool based on if user has stored cache of data
  loadImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? images = prefs.getStringList('image');
    if (images != null) {
      //images.sort();
      setState(() {
        listOfImgStrings = filteredListOfImgStrings = images;
      });
    } else {
      setState(() {
        filteredListOfImgStrings = listOfImgStrings = [];
      });
    }
  }

  // Function that allows users to search for a specific rapper
  void filterByName(String val) {
    setState(() {
      // FilteredArtists is all of the artists whos name contains the value the user types to search for
      filteredArtists = allArtists
          .where((artist) =>
              artist.name.toString().toLowerCase().contains(val.toLowerCase()))
          .toList();

      // Remove location and extention of the file
      List<String> newListOfImg = [];
      listOfImgStrings.forEach((element) {
        newListOfImg.add(
          element
              .replaceAll(
                  "/data/user/0/com.example.rapper_app/app_flutter/", "")
              .replaceAll(".jpeg", ""),
        );
      });

      // Narrow down to just names searched
      filteredListOfImgStrings = newListOfImg
          .where((image) =>
              image.toString().toLowerCase().contains(val.toLowerCase()))
          .toList();
      // Clear the new list so we can add the filtered to it
      newListOfImg.clear();

      // Replace the location
      filteredListOfImgStrings.forEach((element) {
        newListOfImg.add(element.replaceAll(
            "$element",
            "/data/user/0/com.example.rapper_app/app_flutter/" +
                element +
                ".jpeg"));
      });

      // put filtered images into fildered variable
      filteredListOfImgStrings = newListOfImg;
    });
  }

  // Function sets the value of fileExists in the cache
  void setFileExistsSharedPref(bool fileExists) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fileExists', fileExists);
  }

  // Function changes value of fileExists bool based on if user has stored cache of data
  void getFileExistsSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? exists = prefs.getBool('fileExists');
    if (exists != null) {
      await loadImages();
      await loadFile();

      setState(() {
        fileExists = exists;
      });
      // Call setupFile() function after we have fileExists variable
      setupFile();
    } else {
      setState(() {
        fileExists = false;
      });
      // Call setupFile() function after we have fileExists variable
      setupFile();
    }
  }

  // Save file to cache - Takes in encoded json string
  saveFile(String file) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('file', file);
  }

  // Load file from cache - outputs encoded json string
  loadFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fileString = prefs.getString('file');
    setState(() {
      fileContentString = fileString!;
    });
  }

  // Create a .json file in cache
  void createFile(String content) {
    File file = new File(dir!.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(content);
  }

  // Write to the .json file that is stored in the cache
  void writeFile(String content) {
    // If file exists, then write to it,
    if (fileExists) {
      jsonFile!.writeAsStringSync(content);
      // Save the file when we are done writing
      saveFile(fileContentString);
    } else {
      // Else, create a file
      createFile(content);
    }
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
