import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/moduels/cubit/cubit.dart';
import 'package:to_do_app/moduels/cubit/states.dart';
import 'package:to_do_app/shared/components/Component.dart';

class ArchivedTaskScreen extends StatelessWidget {
  const ArchivedTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (BuildContext context, Object? state) {  },
      builder: (BuildContext context, state) {
        var cubit=  AppCubit.get(context);
        return builderTaskConditional(tasks: cubit.archivedTasks);
      },
    );
  }
}
