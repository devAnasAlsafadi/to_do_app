import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/moduels/cubit/states.dart';
import 'package:to_do_app/moduels/nav_moduels/archived_task.dart';
import 'package:to_do_app/moduels/nav_moduels/done_task.dart';
import 'package:to_do_app/moduels/nav_moduels/new_task.dart';

import '../../shared/components/constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Widget> activityList = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> titles = ["New Task", "Done Task", "Archived Task"];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database db;
  void createDataBase() {
    openDatabase("to_do.db", version: 1,
        onCreate: (dataBase, version) async {
      print("dataBase Created!");
      dataBase.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT) ')
          .then((value) {
        print("table created!");
      }).catchError((error) {
        print('Error is : ${error}');
      });
    },
        onOpen: (dataBase) {
      getDataFromDataBase(dataBase);
      print("Is Opened!");
    }).then((value) {
      db = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDataBase(
      {required String title,
      required String time,
      required String date}) async {
    await db.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title" , "$date" ,"$time", "new" )')
          .then((value) {
        print('$value inserted Raw');
        emit(AppInsertDatabaseState());
        getDataFromDataBase(db);
      }).catchError((error) {
        print('the error is : ${error}');
      });
    });
  }

  void getDataFromDataBase(database)  {
    newTasks = [];
    doneTasks =[];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
      database.rawQuery("select * from tasks").then((value) {
        emit(AppGetDatabaseState());
        value.forEach((element) {
          if(element['status'] == 'new'){
            newTasks.add(element);
          }else if(element['status'] == 'done'){
            doneTasks.add(element);
          }else{
            archivedTasks.add(element);
          }
        });
      });
  }
  void deleteData({required int id}) async{
    await db.rawDelete('DELETE FROM tasks WHERE id =?',[id]).then((value) {
    getDataFromDataBase(db);
    emit(AppDeleteDatabaseState());
    });
  }

  void update({
    required String status,
    required int id,
  }) async {
    await db.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          getDataFromDataBase(db);
      emit(AppUpdateDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData iconData = Icons.edit;
  void changeStateBottomSheet({required IconData icon, required bool isShow}) {
    isBottomSheetShown = isShow;
    iconData = icon;
    emit(AppChangeBottomSheetState());
  }
}
