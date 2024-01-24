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
import 'package:intl/intl.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: ProfileCubit.get(context)..creditDateValidation(context: context),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocProvider.value(
            value: BookingCubit.get(context)..changeSelectedDay(DateTime.now())..getRecentBookedClasses(context: context),
            child: BlocConsumer<BookingCubit, BookingState>(
              listener: (context, state) {},
              builder: (context, state) {
                var profCubit = ProfileCubit.get(context);
                var bCubit = BookingCubit.get(context);
                return profCubit.userDataModel!=null?
                Container(
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
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text('GYM credit Balance: ${profCubit.userDataModel!.currentCredit}',
                                        style: TextStyle(fontSize: 15),),
                                      Text('GYM credit Used: ${profCubit.userDataModel!.packageSize!.toInt()-profCubit.userDataModel!.currentCredit!.toInt()}',
                                        style: TextStyle(fontSize: 15,
                                            color: Colors.yellow.shade900),),
                                      Text(
                                        '${profCubit.userDataModel!.currentCredit!} credit expireing on '
                                            '${profCubit.userDataModel!.endCreditDate!.toDate().day} '
                                            '${DateFormat.MMM().format(profCubit.userDataModel!.endCreditDate!.toDate())} '
                                            '${profCubit.userDataModel!.endCreditDate!.toDate().year}',
                                        style: TextStyle(fontSize: 15,
                                            color: Colors.teal.shade600),),
                                    ],
                                  ),
                                ),
                              ),
                               Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child:  profCubit.userDataModel!.packageSize!.toInt()==0 && profCubit.userDataModel!.currentCredit!.toInt()==0?
                                    CreditIndicatorBlock(percent: 1):
                                CreditIndicatorBlock(percent: (profCubit.userDataModel!.packageSize!.toInt() - profCubit.userDataModel!.currentCredit!.toInt())/profCubit.userDataModel!.packageSize!.toInt()),
                              ),
                            ],
                          ),
                        ),
                        profCubit.userDataModel!=null?
                        Expanded(
                          child: ListView.separated(
                            physics:BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                              itemBuilder:(context, index) =>
                                  ClassContainerBlock(
                                    isBookScreen: false,
                                    canceling: (){},
                                    booking: (){},
                                    isBookingState: false,
                                    bookingModel: BookingClassesModel.fromUserDataModel(
                                        bookingHistory: bCubit.recentClasses[index]
                                    ),
                                    primeColor: Constants.kBlueColor,
                                    textColor: Colors.grey.shade700,
                                    backgroundColor: Colors.white,
                                    isHistoryState: true,
                                    ownerDeleteClass: () async {
                                     // await  bCubit.deleteGymClass(docId:bCubit.availableClassesModel[index].docId!,context: context);
                                    },
                                    ownerAuthoize: ProfileCubit.get(context).userDataModel!.priority=='1'?true:false,
                                  ),
                              separatorBuilder: (context, index) => const SizedBox(height: 10,),
                              itemCount: bCubit.recentClasses.length),
                        ):Center(child: CircularProgressIndicator(color: Colors.blue,))
                      ],
                    ),
                  ),
                ):
                const Center(child: CircularProgressIndicator(color: Colors.blue,),);
              },
            ),
          );
        },
      ),
    );
  }
}
