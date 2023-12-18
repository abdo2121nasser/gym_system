import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/blocks/class_container_block.dart';
import 'package:gym/core/blocks/credit_slider_block.dart';
import 'package:gym/core/constants/constants.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/core/models/firebase_models/booking_data_data_model.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return BlocConsumer<BookingCubit, BookingState>(
          listener: (context, state) {
          },
          builder: (context, state) {
            var profCubit = ProfileCubit.get(context);
            var bCubit = BookingCubit.get(context);

            // bool isBooked({required String classId}) {
            //   for (int i = 0; i <
            //       profCubit.userDataModel!.bookingHistory!.length; i++) {
            //     if (profCubit.userDataModel!.bookingHistory![i].subDocId
            //         .contains(classId)) {
            //       return true;
            //     }
            //   }
            //   return false;
            // }


            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10),
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('GYM credit Balance: 14',
                                    style: TextStyle(fontSize: 15),),
                                  Text('GYM credit Used: 16',
                                    style: TextStyle(fontSize: 15,
                                        color: Colors.yellow.shade900),),
                                  Text('14 credit expireing 01 February 2024',
                                    style: TextStyle(fontSize: 15,
                                        color: Colors.teal.shade600),),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: CreditIndicatorBlock(),
                          ),
                        ],
                      ),
                    ),
                    // profCubit.userDataModel!=null?
                    // Expanded(
                    //   child: ListView.separated(
                    //     physics:BouncingScrollPhysics(),
                    //     padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    //       itemBuilder:(context, index) => ClassContainerBlock(
                    //         ownerAuthoize: false,
                    //           canceling: () async {
                    //           await  bCubit.cancelClassGymFromHistory(context: context,mainDocId: profCubit!.userDataModel!.docId!,
                    //                 subDocId: bCubit.bookedClasses[index].currentSubDocId
                    //             );
                    //             // await bCubit.getBookedClasses(context: context);
                    //
                    //           // if(state is CancelBookedGymClassSuccessState) {
                    //           //   await   BookingCubit.get(context).getBookedClasses(context: context);
                    //           //   print('------------------------------');
                    //           // }
                    //             print('${bCubit.bookedClasses.length}-----------------------------');
                    //
                    //
                    //           },
                    //           booking: (){},
                    //           ownerDeleteClass: (){},
                    //         isBookingState: false,// its right --
                    //         bookingModel: BookingClassesModel.fromUserDataModel(
                    //           customerNumber1:bCubit.bookedClasses[index].customerNumber ,
                    //             docId1: bCubit.bookedClasses[index].subDocId, maxCustomerNumber1: bCubit.bookedClasses[index].maxCustomerNumber,
                    //             couchName1: bCubit.bookedClasses[index].couchName, startTimeHour1: bCubit.bookedClasses[index].startTimeHour,
                    //             startTimeMinute1: bCubit.bookedClasses[index].startTimeMinute, startDate1: bCubit.bookedClasses[index].startDate,
                    //             className1: bCubit.bookedClasses[index].className
                    //         ),
                    //           primeColor: Constants.kBlueColor,
                    //           textColor: Colors.grey.shade700,
                    //           backgroundColor: Colors.white,
                    //         ),
                    //       separatorBuilder: (context, index) => const SizedBox(height: 10,),
                    //       itemCount: bCubit.bookedClasses.length),
                    // ):Center(child: CircularProgressIndicator(color: Colors.blue,))
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
