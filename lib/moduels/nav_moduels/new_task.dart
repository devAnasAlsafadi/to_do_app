import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/moduels/cubit/cubit.dart';
import 'package:to_do_app/moduels/cubit/states.dart';
import 'package:to_do_app/shared/components/Component.dart';
import 'package:to_do_app/shared/components/constants.dart';

class NewTaskScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (BuildContext context, Object? state) {  },
      builder: (BuildContext context, state) {
        var cubit=  AppCubit.get(context);
        print('task is sss: ${cubit.newTasks.length}');
        return builderTaskConditional(tasks: cubit.newTasks);
      },
    );
  }
}
