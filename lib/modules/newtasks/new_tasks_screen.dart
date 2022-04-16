import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:day_organizer/shared/cubit/cubit.dart';
import 'package:day_organizer/shared/cubit/states.dart';

import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).tasks;
        return ListView.separated(
            itemBuilder: (context, index) => buildtaskitem(tasks[index]),
            separatorBuilder: (context, index) => Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
            itemCount: tasks.length);
      },
    );
  }
}
