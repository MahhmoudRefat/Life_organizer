import 'package:bloc/bloc.dart';
import 'package:day_organizer/shared/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defultbutton({
  double width = double.infinity,
  Color background = Colors.blue,
  required VoidCallback function,
  required String? text,
}) =>
    Container(
      width: double.infinity,
      color: Colors.blue,
      child: MaterialButton(
        onPressed: function,
        textColor: Colors.white,
        child: Text(text!),
      ),
    );

Widget defultformfild({
  required TextEditingController contrller,
  required TextInputType type,
  required String? Function(String?)? validator,
  void Function(String)? onSubmit,
  void Function(String)? onchanged,
  VoidCallback? ontap,
  required String label,
  IconData? prefixicon,
  IconData? suffixIcon,
  bool IsClieckable = true,
}) =>
    TextFormField(
      controller: contrller,
      keyboardType: type,
      obscureText: false,
      enabled: IsClieckable,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefixicon),
        suffixIcon: Icon(suffixIcon),
      ),
      onFieldSubmitted: onSubmit,
      onTap: ontap,
      onChanged: onchanged,
      validator: validator,
    );

Widget buildtaskitem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        AppCubit.get(context).delelteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text("${model['time']}"),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model['title']}",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${model['date']}",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon: Icon(Icons.check_box),
              color: Colors.blue,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'archive',
                  id: model['id'],
                );
              },
              icon: Icon(Icons.star_border_outlined),
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
