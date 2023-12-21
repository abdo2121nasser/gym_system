import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym/core/blocks/general_button_block.dart';
import 'package:gym/core/constants/constants.dart';
import 'package:gym/core/models/firebase_models/booking_data_data_model.dart';
import 'package:intl/intl.dart';


class ClassContainerBlock extends StatelessWidget {
  final  BookingClassesModel bookingModel;
 final Color primeColor,textColor,backgroundColor;
 final bool ownerAuthoize,isBookingState,isHistoryState,isClassPassed;
   final VoidCallback? ownerDeleteClass,booking,canceling;
  ClassContainerBlock({
    this.isClassPassed=false,
    this.isHistoryState=false,
    required this.canceling,
    required this.booking,
    required this.isBookingState,
    this.ownerDeleteClass,
    required this.bookingModel,
    required this.primeColor,required this.textColor,
    required this.backgroundColor,this.ownerAuthoize=true});

  @override
  Widget build(BuildContext context) {
    return  Container(
         width: double.maxFinite,
      height: 191,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow:  const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 6,
            offset: Offset(0, 4), // Shadow position
          ),
        ],
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Column(

          mainAxisAlignment: !ownerAuthoize || isHistoryState?
          MainAxisAlignment.spaceEvenly: MainAxisAlignment.start,

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(bookingModel.className!,
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:primeColor),),
               if(ownerAuthoize)
                IconButton(
                  onPressed: ownerDeleteClass,
                  icon: Icon(Icons.delete,color: Colors.red,),
                iconSize: 25),

              ],
            ),
           if(!ownerAuthoize)
           SizedBox(height: 10,),
            Row(
              children: [
                Icon(Icons.access_time_rounded,color: Constants.kBlueColor,),
                SizedBox(width: 10,),
                Expanded(
                  child: Text('${DateFormat('EEEE').format(bookingModel.startDate!.toDate())} '
                      '${bookingModel.startDate!.toDate().day.toString()} '
                      '${DateFormat('MMM').format(bookingModel.startDate!.toDate())} '
                      '${bookingModel.startDate!.toDate().year}, ${((bookingModel.startTimeHour!)+(bookingModel.startTimeMinute!/100)).toStringAsFixed(2)} -> ${((bookingModel.startTimeHour!+2)+(bookingModel.startTimeMinute!/100)).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16,color: textColor),),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                Icon(Icons.person,color: Constants.kBlueColor,),
                SizedBox(width: 10,),
                Text(bookingModel.couchName!,
                  style: TextStyle(fontSize: 16,color: textColor),),
              ],
            ),
            isHistoryState || isClassPassed?
            SizedBox()
            : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${bookingModel.maxCustomerNumber!.toInt()-bookingModel.customerNumber!} places left',
                  style: TextStyle(fontSize: 16,color: Colors.red),),
                GeneralButtonBlock(
                    lable:isBookingState? 'Book':'cancel', function:isBookingState? booking!:canceling!,
                    width: double.infinity, hight: 0,
                    textColor: Colors.white, backgroundColor: isBookingState?Colors.blue:Colors.red,
                    borderRadius: 10)
              ],
            ),
          ],
        ),
      ),
    );

  }
}
