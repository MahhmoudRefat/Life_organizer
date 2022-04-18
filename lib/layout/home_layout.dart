import 'package:day_organizer/shared/componants/componants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:day_organizer/modules/archivedtasks/archived_tasks_screen.dart';
import 'package:day_organizer/modules/donetasks/done_tasks_screen.dart';
import 'package:day_organizer/modules/newtasks/new_tasks_screen.dart';
import 'package:day_organizer/shared/cubit/cubit.dart';
import 'package:day_organizer/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class HomeLatout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var n = null;

  var titleController = TextEditingController();
  var timeeController = TextEditingController();
  var datecontroller = TextEditingController();
  var formKey = GlobalKey<FormState>();

  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..CreateDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppState state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.CurrentINdex]),
            ),
            body: cubit.screens[cubit.CurrentINdex],
            /*true
                // state is! AppGetDatabaseLodingState
                ? Center(child: CircularProgressIndicator())
                : cubit.screens[cubit.CurrentINdex],*/
            /*  body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLodingState,
              builder: (context) => cubit.screens[cubit.CurrentINdex],
              fallback: (context) => Center(child: CircularProgressIndicator()), */
            //************floatingaction button************
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomShowen == true) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeeController.text,
                      date: datecontroller.text,
                    );
                  }
                }
                //****************bottom sheet *************
                else {
                  scaffoldKey.currentState
                      ?.showBottomSheet((context) => Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //****** new task */
                                defultformfild(
                                    contrller: titleController,
                                    type: TextInputType.text,
                                    prefixicon: Icons.title,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "title must not be emty";
                                      }
                                      return null;
                                    },
                                    label: 'task title '),
                                SizedBox(
                                  height: 15,
                                ),
                                //*******time tap****
                                defultformfild(
                                  contrller: timeeController,
                                  type: TextInputType.datetime,
                                  // IsClieckable: false,
                                  prefixicon: Icons.watch_later_outlined,
                                  label: 'task time ',
                                  ontap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "time must not be emty";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                //*******date tap****
                                defultformfild(
                                  contrller: datecontroller,
                                  type: TextInputType.datetime,
                                  prefixicon: Icons.date_range,
                                  //   IsClieckable: false,
                                  label: 'date time ',
                                  ontap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-05-03'),
                                    ).then((value) {
                                      _dateTime = value;
                                      //value.toString();
                                      // datecontroller.text =
                                      //     DateFormat.yMMMd(value).toString();
                                      datecontroller.text = DateFormat.yMMMd()
                                          .format(DateTime.now());
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "date must not be emty";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.ChangeBottomSheetState(
                      IsShow: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.ChangeBottomSheetState(
                    IsShow: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabicon,
              ),
            ),
            //************ButtomNavigation button************
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).CurrentINdex,
              onTap: (index) {
                cubit.ChangeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(icon: Icon(Icons.check), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.star), label: "Bookmarked"),
              ],
            ),
          );
        },
      ),
    );
  }
}
