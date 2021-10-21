import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapper_app/cubits/navCubit.dart';
import 'package:rapper_app/repos/rapperRepo.dart';
import 'package:rapper_app/widgets/appNav.dart';

import 'blocs/rapperBloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rapper App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NavCubit()),
          BlocProvider(
            create: (context) => RapperBloc(RapperRepo()),
          ),
        ],
        child: AppNavigator(),
      ),
    );
  }
}
