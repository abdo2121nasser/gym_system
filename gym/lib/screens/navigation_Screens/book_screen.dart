// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/app_root/material_app.dart';
import 'package:gym/core/blocks/calender_block.dart';
import 'package:gym/core/blocks/class_container_block.dart';
import 'package:gym/core/blocks/general_button_block.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../core/constants/constants.dart';
import '../other_screens/class_customer_list_screen.dart';


class BookScreen extends StatefulWidget {
  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  int cancelDialogeindex=0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    return BlocProvider.value(
      value: BookingCubit.get(context),
  child: BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var profCubit = ProfileCubit.get(context);
        var bCubit = BookingCubit.get(context);

        bool isBooked({required String classId}) {
          for (int i = 0; i < bCubit.historyClasses.length; i++) {
            if (bCubit.historyClasses[i].subDocId.contains(classId)) {
              return true;
            }
          }
          return false;
        }
        isBeforeTimeMoreThan24Hour(int index)
        {
          DateTime customDateTime = DateTime(bCubit.availableClassesModel[index].startDate!.toDate().year,
              bCubit.availableClassesModel[index].startDate!.toDate().month,
              bCubit.availableClassesModel[index].startDate!.toDate().day,
              bCubit.availableClassesModel[index].startTimeHour!,
              bCubit.availableClassesModel[index].startTimeMinute!);
          if(DateTime.now().isBefore(customDateTime.subtract(const Duration(hours: 24))))
            {
              return true;
            }
          else
            {
              return false;
            }

        }




        return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            children: [
              const CalenderBlock(),
              const Divider(color: Colors.black87, thickness: 1,),
                profCubit.userDataModel==null || state is GetAllAvailableClassLoadingState?
                    const Center(child: CircularProgressIndicator(color: Colors.blue,),):
                Expanded(
                  child: ListView.separated(
                      physics:const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      itemBuilder:(context, index) =>
                          InkWell(
                            onTap: () async {
                              if (profCubit.userDataModel!.priority =='2')
                              {

                                await bCubit.getClassCustomerList( mainDocId: bCubit.availableClassesModel[index].docId!);
                                if(
                                bCubit.availableClassesModel[index].startDate!.toDate().year.toInt()>= DateTime.now().year.toInt()
                                    &&  bCubit.availableClassesModel[index].startDate!.toDate().month.toInt()>= DateTime.now().month.toInt()
                                    &&  bCubit.availableClassesModel[index].startDate!.toDate().day.toInt()>= DateTime.now().day.toInt()
                                )
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      ClassCustomerListScreen(
                                        mainDocId: bCubit.availableClassesModel[index].docId!,
                                        isClassPassed: false,
                                      ),));
                                }
                                else
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      ClassCustomerListScreen(
                                        mainDocId: bCubit.availableClassesModel[index].docId!,
                                        isClassPassed: true,
                                      ),));
                                }

                              }
                            },
                            child: ClassContainerBlock(
                              canceling: () async {
                                if(
                                    bCubit.isTheDateNotPassed(
                                    hour: bCubit.availableClassesModel[index].startTimeHour!,
                                    minute: bCubit.availableClassesModel[index].startTimeMinute!,
                                    date: bCubit.availableClassesModel[index].startDate!.toDate())
                                && isBeforeTimeMoreThan24Hour(index)
                                ) {
                                  await bCubit.cancelBookedClass(
                                      index: index,
                                      mainDocId: bCubit.availableClassesModel[index].docId!, email: profCubit.userDataModel!.email!,
                                      customerNumber: bCubit.availableClassesModel[index].customerNumber!,
                                      context: context
                                      ,historyMainDocId: profCubit.userDataModel!.docId!,
                                      historySubDocId: bCubit.getClassDocIdValue(searchValue:bCubit.availableClassesModel[index].docId!, context: context)
                                  );
                                  await bCubit.getAllAvailableClass();
                                }
                                else
                                {
                                  showDialog(context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        insetPadding: const EdgeInsets.symmetric(vertical: 170,horizontal: 40),
                                        content: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text('if you canceled your booking before its start time with 24 hour you wont get your cridet back',
                                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GeneralButtonBlock(
                                                    lable: 'Ok', function: () async {
                                                      if(bCubit.classInProgress==false || cancelDialogeindex==0) {
                                                        cancelDialogeindex=1;
                                                        await Future.delayed(const Duration(seconds: 0)).then((value) async {
                                                   await bCubit.cancelBookedClass(
                                                       isIncrement: false,
                                                       index: index,
                                                       mainDocId: bCubit.availableClassesModel[index].docId!, email: profCubit.userDataModel!.email!,
                                                       customerNumber: bCubit.availableClassesModel[index].customerNumber!,
                                                       context: context
                                                       ,historyMainDocId: profCubit.userDataModel!.docId!,
                                                       historySubDocId: bCubit.getClassDocIdValue(searchValue:bCubit.availableClassesModel[index].docId!, context: context)
                                                   );
                                                 }).then((value) async {
                                                   await bCubit.getAllAvailableClass();
                                                 }).then((value) {
                                                   Navigator.of(context).pop();
                                                   cancelDialogeindex=0;
                                                 });
                                                      }
                                                },
                                                    width: 100, hight: 30, textColor: Colors.white,
                                                    backgroundColor: Colors.red, borderRadius: 10),
                                                GeneralButtonBlock(
                                                    lable: 'cancel', function: (){
                                                      if(cancelDialogeindex==0/*bCubit.classInProgress==false*/) {
                                                        Navigator.pop(context);
                                                      }
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
                                     bCubit.isTheDateNotPassed(hour: bCubit.availableClassesModel[index].startTimeHour!,
                                    minute: bCubit.availableClassesModel[index].startTimeMinute!,
                                    date: bCubit.availableClassesModel[index].startDate!.toDate())
                                    && (bCubit.availableClassesModel[index].maxCustomerNumber!.toInt() - bCubit.availableClassesModel[index].customerNumber!) >=0
                                    )
                                    {
                                      await  bCubit.bookClass(index: index,
                                          context: context,
                                          classDocId: bCubit.availableClassesModel[index].docId!, object: profCubit.userDataModel!
                                          ,historyDocId:  profCubit.userDataModel!.docId!,
                                          historyObject: bCubit.availableClassesModel[index]);
                                      await bCubit.getAllAvailableClass();

                                    }
                                    else
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('this class its start time has been passed----')));
                                    }
                                  }
                                  else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("sorry you don't have enough credit balance to buy it")));
                                  }
                                }
                                else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('sorry but the class already is full'),duration: Duration(seconds: 1),));
                                }
                              },
                              ownerDeleteClass: () async {
                               await Future.delayed(const Duration(seconds: 0)).then((value) async {
                                  await  bCubit.deleteGymClass(docId:bCubit.availableClassesModel[index].docId!,index: index,context: context);
                                }).then((value) async {
                                 await bCubit.getAllAvailableClass();
                               });
                              },
                              isClassPassed: !bCubit.isTheDateNotPassed(
                                  hour: bCubit.availableClassesModel[index].startTimeHour!,
                                  minute: bCubit.availableClassesModel[index].startTimeMinute!,
                                  date: bCubit.availableClassesModel[index].startDate!.toDate()),
                              isBookingState: !isBooked(classId: bCubit.availableClassesModel[index].docId!),
                              bookingModel: bCubit.availableClassesModel[index],
                              isBookScreen: true,
                              primeColor: Constants.kBlueColor,
                              textColor: Colors.grey.shade700,
                              backgroundColor: Colors.white,
                              ownerAuthoize: profCubit.userDataModel!.priority=='1'?true:false,
                              classInProgress: bCubit.classInProgress[index],
                              classInDeleting: bCubit.classInDeleting[index],

                            ),
                          ),

                      separatorBuilder: (context, index) => const SizedBox(height: 10,),
                      itemCount: bCubit.availableClassesModel.length),
                )

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