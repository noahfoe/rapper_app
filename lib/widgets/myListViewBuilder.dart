import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapper_app/blocs/rapperBloc.dart';
import 'package:rapper_app/models/rapperModel.dart';
import 'package:rapper_app/screens/screens.dart';
import 'package:google_fonts/google_fonts.dart';

class MyListViewBuilder extends StatefulWidget {
  final List<Artist>? data;
  final List<String>? images;
  MyListViewBuilder({Key? key, this.data, this.images}) : super(key: key);

  @override
  _MyListViewBuilderState createState() => _MyListViewBuilderState();
}

class _MyListViewBuilderState extends State<MyListViewBuilder> {
  @override
  void initState() {
    super.initState();
    // Sort Images
    sortImages();
    // Sort Rappers Info
    sortData();
  }

  @override
  void didUpdateWidget(covariant MyListViewBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.images != widget.images) {
      // Sort Images
      sortImages();
    }
    if (oldWidget.data != widget.data) {
      // Sort Rappers Info
      sortData();
    }
  }

  sortImages() {
    widget.images!.sort();
  }

  sortData() {
    widget.data!.sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    final _rapperBloc = BlocProvider.of<RapperBloc>(context);
    // Make sure we have same length of images and names/descriptions
    if (widget.images!.length == widget.data!.length) {
      // Create a listView of the Rappers
      return BlocConsumer<RapperBloc, RapperState>(
        listener: (context, state) {
          if (state is RapperIsSelected) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MySecondPage(
                        // Pass parameters the description page needs
                        desc: state.getRapperDesc,
                        name: state.getRapperName)));
          }
        },
        builder: (context, state) {
          return ListView.builder(
            // Count changes based on search bar results
            itemCount: widget.data!.length,
            itemBuilder: (BuildContext context, int index) {
              // GestureDetector to check if user taps on the card
              return GestureDetector(
                onTap: () {
                  // If user taps on an artist, send them to description page
                  _rapperBloc.add(SelectRapper(widget.data![index].name,
                      widget.data![index].description));
                  /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MySecondPage(
                            // Pass parameters the description page needs
                            desc: widget.data![index].description,
                            name: widget.data![index].name),
                      
                      ),
                      
                    );
                    */
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  // Card for each artist
                  child: Card(
                    elevation: 15,
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
                      // Row for text and image inside the card
                      child: Row(
                        children: [
                          const Spacer(flex: 1),
                          // Spacers between text to center it
                          // Display name of each rapper
                          Text(
                            widget.data![index].name,
                            style: GoogleFonts.lato(
                                textStyle:
                                    TextStyle(fontSize: 20, letterSpacing: .5)),
                          ),
                          const Spacer(flex: 1),
                          // Display image of each rapper
                          Image.file(
                            File(widget.images![index].toString()),
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
        },
      );
    } else {
      // Platform specific loading animation
      return Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator()
            : CupertinoActivityIndicator(),
      );
    }
  }
}
