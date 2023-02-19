import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/moduels/cubit/cubit.dart';
import 'package:to_do_app/moduels/cubit/states.dart';
import 'package:to_do_app/shared/components/Component.dart';


class HomeScreen extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (BuildContext context , AppStates state){},
        builder: (BuildContext context , AppStates state){
          var cubit=  AppCubit.get(context);
           return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.titles[cubit.currentIndex]),
              ),
              body: ConditionalBuilder(
                condition: state is! AppGetDatabaseLoadingState,
                builder:(context) => cubit.activityList[cubit.currentIndex] ,
                fallback: (context) => Center(child: CircularProgressIndicator()),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(cubit.iconData),
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if(formKey.currentState!.validate()){
                      cubit.insertToDataBase(title: titleController.text, time: timeController.text, date: dateController.text);
                      Navigator.pop(context);
                      cubit.changeStateBottomSheet(icon: Icons.edit, isShow: false);
                    }

                  } else {
                    scaffoldKey.currentState!.showBottomSheet((context) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),

                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultTextFormFiled(
                                control: titleController,
                                type: TextInputType.text,
                                text: "Title",
                                prefix: Icon(Icons.title),
                                validation: (String? value) {
                                  if(value!.isEmpty){
                                    return "Title must not be Empty!";
                                  }
                                  return null;
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              onTap: (){
                                showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
                                  timeController.text = value!.format(context).toString();
                                });
                              },

                              decoration: InputDecoration(
                                  label: Text("Time Task"),
                                  prefixIcon: Icon(Icons.watch_later_outlined),
                                  border: OutlineInputBorder()
                              ),
                              validator: (String? value) {
                                if(value!.isEmpty){
                                  return "Time must not be Empty!";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              onTap: (){
                                showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate:DateTime.parse("2023-10-08")).then((value) {
                                  dateController.text = DateFormat.yMMMd().format(value!);

                                });
                              },

                              decoration: InputDecoration(
                                  label: Text("Date Task"),
                                  prefixIcon: Icon(Icons.calendar_month),
                                  border: OutlineInputBorder()
                              ),
                              validator: (String? value) {
                                if(value!.isEmpty){
                                  return "Date must not be Empty!";
                                }
                                return null;
                              },
                            )
                          ],
                        ),
                      ),
                    ),elevation: 15).closed.then((value) {
                    cubit.changeStateBottomSheet(icon: Icons.edit, isShow: false);
                    });
                    cubit.changeStateBottomSheet(icon: Icons.add, isShow: true);
                  }
                },
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                 cubit.changeIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: "Tasks",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline_outlined),
                    label: "Done",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: "Archived",
                  ),
                ],
              ));
        },
      ),
    );
  }



}
