import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';

import '../../core/blocks/class_container_block.dart';
import '../../core/constants/constants.dart';
import '../../core/cubits/profile_cubit/profile_cubit.dart';
import '../../core/models/firebase_models/booking_data_data_model.dart';


class MyScheduleScreen extends StatelessWidget {
final String couchName;

MyScheduleScreen({required this.couchName});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return BlocProvider.value(
          value: BookingCubit.get(context)..getMyDailySchedule(couchName: couchName),
          child: BlocConsumer<BookingCubit, BookingState>(
            listener: (context, state) {
            },
            builder: (context, state) {
              var bCubit = BookingCubit.get(context);
              var profCubit = ProfileCubit.get(context);
              return SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.blue,
                    centerTitle: true,
                    title: Text('My Schedule',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),),
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            itemBuilder: (context, index) =>
                                ClassContainerBlock(
                                  canceling: () {},
                                  booking: () {},
                                  isBookingState: false,
                                  bookingModel: bCubit.myDailySchedulModel[index],
                                  primeColor: Constants.kBlueColor,
                                  textColor: Colors.grey.shade700,
                                  backgroundColor: Colors.white,
                                  isHistoryState: true,
                                  ownerDeleteClass: () {},
                                  ownerAuthoize: ProfileCubit.get(context).userDataModel!.priority == '1' ? true : false,
                                ),
                            separatorBuilder: (context, index) =>
                            const SizedBox(height: 10,),
                            itemCount: bCubit.myDailySchedulModel.length),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
