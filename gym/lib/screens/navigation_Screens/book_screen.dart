import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/blocks/calender_block.dart';
import 'package:gym/core/blocks/class_container_block.dart';
import 'package:gym/core/blocks/general_button_block.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/constants/constants.dart';


class BookScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    return BlocProvider.value(
      value: BookingCubit.get(context)..getHistroyGymClasses(context: context),
  child: BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var profCubit = ProfileCubit.get(context);
        var bCubit = BookingCubit.get(context);

        bool isBooked({required String classId}) {
          for (int i = 0; i < bCubit.historyClasses!.length; i++) {
            if (bCubit.historyClasses[i].subDocId.contains(classId)) {
              return true;
            }
          }
          return false;
        }

       bool isClassPassed({required int index}) {
          if(
           bCubit.availableClassesModel[index].startDate!.toDate().year.toInt()<= DateTime.now().year.toInt()
              &&  bCubit.availableClassesModel[index].startDate!.toDate().month.toInt()<= DateTime.now().month.toInt()
          &&  bCubit.availableClassesModel[index].startDate!.toDate().day.toInt()< DateTime.now().day.toInt()
          )
            {
              return true;
            }
          else if(bCubit.availableClassesModel[index].startDate!.toDate().day.toInt()== DateTime.now().day.toInt()
              && bCubit.availableClassesModel[index].startTimeHour!.toInt()< DateTime.now().hour.toInt())
            {
              return true;
            }
          return false;
        }




        return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            children: [
              CalenderBlock(),
              Divider(color: Colors.black87, thickness: 1,),
                profCubit.userDataModel!=null?
              Expanded(
                child: ListView.separated(
                    physics:BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    itemBuilder:(context, index) => ClassContainerBlock(
                      canceling: () async {
                        if(
                        bCubit.availableClassesModel[index].startDate!.toDate().year.toInt()>= DateTime.now().year.toInt()
                            &&  bCubit.availableClassesModel[index].startDate!.toDate().month.toInt()>= DateTime.now().month.toInt()
                            &&  bCubit.availableClassesModel[index].startDate!.toDate().day.toInt()>= DateTime.now().day.toInt()+2
                          //  &&  bCubit.availableClassesModel[index].startTimeHour!.toInt()> DateTime.now().hour.toInt()
                        ) {
                         await bCubit.cancelBookedClass(mainDocId: bCubit.availableClassesModel[index].docId!, email: profCubit.userDataModel!.email!,
                             customerNumber: bCubit.availableClassesModel[index].customerNumber!,
                             context: context
                              ,historyMainDocId: profCubit.userDataModel!.docId!,
                              historySubDocId: bCubit.getClassDocIdValue(searchValue:bCubit.availableClassesModel[index].docId!, context: context)
                          );
                        }
                        else
                          {
                            showDialog(context: context,
                              builder: (context) {
                                return AlertDialog(
                                  insetPadding: EdgeInsets.symmetric(vertical: 170,horizontal: 40),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('if you canceled your booking before its start time with 24 hour you wont get your cridet back',
                                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GeneralButtonBlock(
                                              lable: 'Ok', function: () async {
                                         await   bCubit.cancelBookedClass(
                                                mainDocId: bCubit.availableClassesModel[index].docId!,
                                                isIncrement: false,
                                                email: profCubit.userDataModel!.email!, context: context,
                                             customerNumber: bCubit.availableClassesModel[index].customerNumber!,
                                                historyMainDocId: profCubit.userDataModel!.docId!,
                                                historySubDocId: bCubit.getClassDocIdValue(searchValue:bCubit.availableClassesModel[index].docId!, context: context)
                                            );
                                           Navigator.of(context).pop();
                                          },
                                              width: 100, hight: 30, textColor: Colors.white,
                                              backgroundColor: Colors.red, borderRadius: 10),
                                          GeneralButtonBlock(
                                              lable: 'cancel', function: (){
                                            Navigator.pop(context);
                                          },
                                              width: double.infinity, hight: 30, textColor: Colors.white,
                                              backgroundColor: Colors.blue, borderRadius: 10),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },);

                          }
                      },
                        booking: () async {
                       if((bCubit.availableClassesModel[index].maxCustomerNumber!.toInt() - bCubit.availableClassesModel[index].customerNumber!.toInt())>0)
                         {
                           if(profCubit.userDataModel!.currentCredit! > 0)
                           {
                             if(
                             bCubit.availableClassesModel[index].startDate!.toDate().year.toInt()>= DateTime.now().year.toInt()
                                 &&  bCubit.availableClassesModel[index].startDate!.toDate().month.toInt()>= DateTime.now().month.toInt()
                                 &&  bCubit.availableClassesModel[index].startDate!.toDate().day.toInt()>= DateTime.now().day.toInt()
                                 && (bCubit.availableClassesModel[index].maxCustomerNumber!.toInt() - bCubit.availableClassesModel[index].customerNumber!) >=0
                             ) {

                               if(bCubit.availableClassesModel[index].startDate!.toDate().day.toInt()== DateTime.now().day.toInt()
                                   && bCubit.availableClassesModel[index].startTimeHour!.toInt()> DateTime.now().hour.toInt()
                               ) {
                                 await  bCubit.bookClass(
                                     context: context,
                                     classDocId: bCubit.availableClassesModel[index].docId!, object: profCubit.userDataModel!
                                     ,historyDocId:  profCubit.userDataModel!.docId!,
                                     historyObject: bCubit.availableClassesModel[index]);

                               }
                               else if(bCubit.availableClassesModel[index].startDate!.toDate().day.toInt()> DateTime.now().day.toInt())
                               {
                                 await    bCubit.bookClass(context: context,
                                     classDocId: bCubit.availableClassesModel[index].docId!, object: profCubit!.userDataModel!
                                     ,historyDocId:  profCubit.userDataModel!.docId!,
                                     historyObject: bCubit.availableClassesModel[index]);
                               }
                               else
                               {
                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('this class its start time has been passed')));
                               }
                             }
                             else
                             {
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('this class its start time has been passed')));
                             }
                           }
                           else
                           {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("sorry you don't have enough credit balance to buy it")));
                           }
                         }
                       else
                         {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('sorry but the class already is full'),duration: Duration(seconds: 1),));
                         }
                        },
                        ownerDeleteClass: () async {
                         await  bCubit.deleteGymClass(docId:bCubit.availableClassesModel[index].docId!,context: context);
                        },
                        isBookingState: !isBooked(classId: bCubit.availableClassesModel[index].docId!),
                        bookingModel: bCubit.availableClassesModel[index],
                        primeColor: Constants.kBlueColor,
                        textColor: Colors.grey.shade700,
                        backgroundColor: Colors.white,
                      ownerAuthoize: profCubit.userDataModel!.priority=='1'?true:false,
                      isClassPassed: isClassPassed(index: index),

                    ),

                    separatorBuilder: (context, index) => const SizedBox(height: 10,),
                    itemCount: bCubit.availableClassesModel.length),
              ):
                    Center(child: CircularProgressIndicator(color: Colors.blue,),)

            ],
          ),
        );
        },

    ),
);
  },
);
  }
}