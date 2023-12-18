import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';

import 'general_button_block.dart';
import 'general_text_field_block.dart';



class AlertDialogBoxBlock extends StatelessWidget {
  TextEditingController className,classMaxCustomerNumber;
  TimeOfDay? classStartTime;
  TextEditingController classCouchName;
  VoidCallback updatetime,addFunction,cancelFunction;
  AlertDialogBoxBlock({
    required this.classMaxCustomerNumber,
    required this.updatetime,required this.addFunction,required this.cancelFunction,
    required this.className,required this.classStartTime,
    required this.classCouchName});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 80,horizontal: 30),
      backgroundColor: Colors.white,
      titlePadding:EdgeInsets.only(top: 20,left: 80,bottom: 10),
      title: Text('Add Class',style: TextStyle(fontWeight: FontWeight.bold),),
      content: Column(
        children: [
          GeneralTextFieldBlock(hint:'Class Name', controller: className),
          const SizedBox(height: 10,),
          InkWell(
            onTap:updatetime,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              width: double.maxFinite,
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo.shade400,width: 2),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time,color: Colors.indigo.shade400,),
                  const SizedBox(width: 5,),
                  const Text('Start Time :',
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                  Text(BookingCubit.get(context).classStartTime!.format(context),
                    style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
          ),

          const SizedBox(height: 10,),
          GeneralTextFieldBlock(hint:'Class Couch', controller: classCouchName),
          SizedBox(height: 10,),
          GeneralTextFieldBlock(hint:'max customer number', controller:classMaxCustomerNumber,onlyInteger: true, ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GeneralButtonBlock(lable: 'Cancel', function: cancelFunction,
                  width: double.infinity, hight: 30,
                  textColor: Colors.white, backgroundColor: Colors.indigo.shade400,
                  borderRadius: 10),
              SizedBox(width: 20,),
              GeneralButtonBlock(lable: 'Add', function: addFunction,
                  width: double.infinity, hight: 30,
                  textColor: Colors.white, backgroundColor: Colors.indigo.shade400,
                  borderRadius: 10),
            ],
          )
        ],
      ),
    );
  },
);
  }

}
