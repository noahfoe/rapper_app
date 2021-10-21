import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapper_app/blocs/rapperBloc.dart';

class MySecondPage extends StatelessWidget {
  final String desc;
  final String name;
  const MySecondPage({Key? key, required this.desc, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RapperBloc, RapperState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            // Display name of rapper that the user tapped
            title: Text(name + "'s Description"),
          ),
          body: Center(
            // Card for description
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 10,
                shadowColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.blue, width: .7),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  // Display description of rapper that user tapped
                  child: Text(
                    desc,
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 30, letterSpacing: .5)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
