import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:day_organizer/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
import '../../modules/archivedtasks/archived_tasks_screen.dart';
import '../../modules/donetasks/done_tasks_screen.dart';
import '../../modules/newtasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context); //easy cubit object
  late Database database;
  List<Map> tasks = [];
  IconData fabicon = Icons.edit;
  bool isBottomShowen = false;
  int CurrentINdex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    "New Task ",
    "Done Task ",
    "Archived Task",
  ];
  void ChangeIndex(int index) {
    CurrentINdex = index;
    emit(AppChangeBottomNavBarState());
  }

//create databse function
  void CreateDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, virsion) {
      print("database ctreated");
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT ,date TEXT,time TEXT , status TEXT)')
          .then((value) {
        print("table created");
      }).catchError((error) {
        print('error when creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDataBase(database).then((value) {
        tasks = value;
        print("$tasks --- 'here is y mahmoud' ");
        emit(AppGetDatabaseState());
      });

      print("----database opend----");
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  //insert to data base function
  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              "INSERT INTO tasks (title,date,time,status)VALUES('$title' ,'$date','$time','new')")
          .then((value) {
        print("$value inserted uccessfully ");
        emit(AppInsertDatabaseState());
        getDataFromDataBase(database).then((value) {
          tasks = value;
          print(tasks);
          emit(AppGetDatabaseState());
        });
      }).catchError((error) {
        print('error when inserting table ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFromDataBase(database) async {
    // emit(AppGetDatabaseLodingState());
    return await database.rawQuery('SELECT * FROM tasks');
  }

  Future<int> updateData({required String status, required int id}) async {
    return await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', ['$status', '$id']);
  }

  void ChangeBottomSheetState({
    required bool IsShow,
    required IconData icon,
  }) {
    isBottomShowen = IsShow;
    fabicon = icon;
    emit(AppChangeBottomSheetState());
  }
}
