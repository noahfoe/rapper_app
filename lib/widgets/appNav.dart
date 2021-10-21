import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapper_app/cubits/navCubit.dart';
import 'package:rapper_app/models/rapperModel.dart';
import 'package:rapper_app/screens/screens.dart';

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, Rapper?>(
      builder: (context, rapper) {
        return Navigator(
          pages: [
            MaterialPage(child: MyHomePage(title: "Rapper App")),
            if (rapper != null)
              MaterialPage(
                  child: MySecondPage(
                      desc: rapper.description, name: rapper.name)),
          ],
          onPopPage: (route, result) {
            BlocProvider.of<NavCubit>(context).popToRappers();
            return route.didPop(result);
          },
        );
      },
    );
  }
}
