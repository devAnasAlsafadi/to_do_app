
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/moduels/cubit/cubit.dart';

Widget defaultTextFormFiled({
required TextEditingController control,
required TextInputType type,
required  String? Function(String?)? validation,
required String text,
required Icon prefix,
Function? onTap,
Function? onSubmit,
Function? onChange,}) => TextFormField(
  controller: control,
  keyboardType: TextInputType.emailAddress,
  validator:validation,
  onTap: onTap!=null?onTap():null,
  onFieldSubmitted: onSubmit!=null?onSubmit():null,
  decoration:  InputDecoration(
      label: Text(text),
      prefixIcon:prefix,
      border: OutlineInputBorder()),
);

Widget buildTaskItem(Map model , context) =>Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(

      children: [

        CircleAvatar(

          child: Text("${model["time"]}"),

          radius: 40.0  ,

        ),

        SizedBox(width: 15,),

        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [

              Text("${model["title"]}",style: TextStyle(color: Colors.black45 ,fontSize: 20.0, fontWeight: FontWeight.bold),),

              SizedBox(height: 5,),

              Text("${model["date"]}",style: TextStyle(color: Colors.grey),),

            ],

          ),

        ),

        SizedBox(width: 15,),

        IconButton(onPressed: (){
          AppCubit.get(context).update(status: 'done', id: model['id']);

        }, icon: Icon(Icons.check_box),color: Colors.green,),

        IconButton(onPressed: (){
          AppCubit.get(context).update(status: 'archived', id: model['id']);

          }, icon: Icon(Icons.archive),color: Colors.black45,),

      ],

    ),

  ),
);

Widget builderTaskConditional({
  required List<Map> tasks
})=>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder:(context)=> ListView.separated(itemBuilder: (context ,index) =>buildTaskItem(tasks[index],context),
          separatorBuilder:(context,index) => Container(
            height: 1.0,
            width: double.infinity,
            color: Colors.grey[300],
          ),
          itemCount:tasks.length
      ),
      fallback:(context)=> Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu,size: 80,color: Colors.grey,),
            Text("No Tasks Yet, Add some Tasks",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w300,color: Colors.grey),)
          ],

        ),
      ),
    );

