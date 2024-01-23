import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/blocks/customer_attend_block.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';


class ClassCustomerListScreen extends StatelessWidget {
   final String mainDocId;
   final bool isClassPassed;

   ClassCustomerListScreen({required this.mainDocId,required this.isClassPassed});

   @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var bCubit=BookingCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: Text('Customer List',
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold
              ),),
            leading: IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back, size: 30,)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    controller: ScrollController(),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                            return CustomerAttendBlock(
                              isClassPassed: isClassPassed,
                              name: bCubit.customerAttendList[index].name,
                              image: bCubit.customerAttendList[index].imageUrl,
                              absentFunction: () {
                                bCubit.setCustomerAbsent(
                                    mainDocId: mainDocId,
                                    subDocId: bCubit.customerAttendList[index].docId,
                                context: context);
                              },
                              attendedFunction: () {},
                              isAttended: true,
                            );

                          },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10,),
                        itemCount:bCubit.customerAttendList.length
                    ),
                  ),
                ),
              const Divider(thickness: 5),
                Expanded(
                  child: Scrollbar(
                    controller: ScrollController(),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                           return CustomerAttendBlock(
                             isClassPassed: isClassPassed,
                             name: bCubit.customerAbsentList[index].name,
                             image: bCubit.customerAbsentList[index].imageUrl,
                             absentFunction: () {},
                             attendedFunction: () {
                               bCubit.setCustomerAttended(mainDocId: mainDocId,
                                   subDocId: bCubit.customerAbsentList[index].docId,
                               context: context );
                             },
                             isAttended: false,
                           );
                         }
                          ,separatorBuilder: (context, index) =>
                            SizedBox(height: 10,),
                        itemCount: bCubit.customerAbsentList.length),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
