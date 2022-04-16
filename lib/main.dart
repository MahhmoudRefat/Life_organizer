import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:day_organizer/layout/home_layout.dart';
import 'package:day_organizer/shared/blocobserver.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      runApp(Run_App());
    },
    blocObserver: MyBlocObserver(),
  );
}

class Run_App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLatout(),
    );
  }
}
