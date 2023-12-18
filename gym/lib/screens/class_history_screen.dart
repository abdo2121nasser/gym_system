import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/blocks/class_container_block.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/core/models/firebase_models/booking_data_data_model.dart';

import '../core/constants/constants.dart';


class ClassHistoryScreen extends StatefulWidget {
  const ClassHistoryScreen({super.key});

  @override
  State<ClassHistoryScreen> createState() => _ClassHistoryScreenState();
}

class _ClassHistoryScreenState extends State<ClassHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BookingCubit.get(context)..getHistroyGymClasses(context: context),
  child: BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var bCubit=BookingCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: const Text('your History',
              style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black87),),
          ),
          body: Column(
            children: [
              Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      itemBuilder: (context, index) => ClassContainerBlock(
                          canceling: (){},
                          booking: (){},
                          isBookingState: false,
                          bookingModel: BookingClassesModel.fromUserDataModel(
                             bookingHistory: bCubit.historyClasses[index]
                          ),
                        primeColor: Constants.kBlueColor,
                        textColor: Colors.grey.shade700,
                        backgroundColor: Colors.white,
                        isHistoryState: true,
                        ownerDeleteClass: (){
                          bCubit.deleteGymClass(docId: bCubit.historyClasses[index].subDocId);
                         bCubit.cancelClassGymFromHistory(mainDocId: ProfileCubit.get(context).userDataModel!.docId!, subDocId: bCubit.historyClasses[index].currentSubDocId, context: context);
                         setState(() {

                         });
                        },
                        ownerAuthoize: ProfileCubit.get(context).userDataModel!.priority=='1'?true:false,
                      ),
                      separatorBuilder: (context, index) => const SizedBox(height: 10,),
                      itemCount:bCubit.historyClasses.length)
              )
            ],
          ),
        );
      },
    ),
);
  }
}
