import 'package:calendar_picker/calendar_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class GeneralTextFieldBlock extends StatelessWidget {
  final String hint;
  bool onlyInteger,canEdit;
  final Icon? preIcon,suffixIcon;
  final TextEditingController controller;
  final Color? hintColor;
  GeneralTextFieldBlock({
    this.canEdit=true,
    this.onlyInteger=false,
    required this.hint,
    required this.controller,
     this.preIcon,
     this.suffixIcon,
    this.hintColor
  });

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      keyboardType: canEdit? TextInputType.text:TextInputType.none,
controller: controller,
        inputFormatters: <TextInputFormatter>[
         if(onlyInteger)
          FilteringTextInputFormatter.digitsOnly,
        ],
      decoration:  InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide:
            BorderSide(width: 1.7,color: Colors.grey.shade600)),
        border:const  OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        label: Text (hint,
        style: TextStyle(
          color: hintColor
        ),),
         labelStyle: const TextStyle(color: Colors.blueAccent),
         prefixIcon: preIcon,

        suffixIcon: suffixIcon!=null?
          InkWell(
            onTap: () {
              showCustomCalendarPicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                excluded: [
                  // DateTime.now().add(const Duration(days: 2)),
                  // DateTime.now().add(const Duration(days: 5)),
                  // DateTime.now().subtract(const Duration(days: 5)),
                ],
                onSelected: (date) {

                  //dataCubit.setTime(isStartDate, date);
                },
              );
            },

            child: suffixIcon,)
            :null,


        hintStyle:const TextStyle(color: Colors.black87,fontSize: 20)
      ),
    );
  }
}
