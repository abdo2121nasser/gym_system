import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/bloc_observer/search_bar_block.dart';
import 'package:gym/core/blocks/general_button_block.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';

import '../core/blocks/general_text_field_block.dart';


class EditCustomerCreditScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var profCubit=ProfileCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            centerTitle: true,
            title: Text('Update Customer Credit',
              style: TextStyle(color: Colors.black87,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
              child: Column(
                children: [
                  SearchBarBlock(
                      controller: TextEditingController(), function: () {}),
                  profCubit.userDataModel!=null?
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10,),
                    Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal,width: 6),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                  image:
                  Image.network(profCubit.userDataModel!.imageUrl!).image

                  )
                  ),

                  ),
                  Text(profCubit.userDataModel!.name!,
                  style: TextStyle(fontSize: 30),),
                                 const SizedBox(height: 10,),
                  GeneralTextFieldBlock(hint: 'current credit', controller: TextEditingController(),canEdit: false,),
                    const SizedBox(height: 10,),
                    GeneralTextFieldBlock(hint: 'new credit', controller: TextEditingController(),onlyInteger: true,),
                    const SizedBox(height: 10,),
                    GeneralTextFieldBlock(hint: 'start credit date', controller:TextEditingController(),canEdit: false,suffixIcon: Icon(Icons.timer_outlined),),
                    const SizedBox(height: 10,),
                    GeneralTextFieldBlock(hint: 'end credit date', controller:TextEditingController(),canEdit: false,suffixIcon: Icon(Icons.timer_off_outlined),),
                    const SizedBox(height: 10,),
                    GeneralButtonBlock(
                        lable: 'Update', function: (){},
                        width: double.maxFinite, hight: 50,
                        textColor: Colors.white, backgroundColor: Colors.blue,
                        borderRadius: 10)
                       ]
                  )

                      :Center(child: CircularProgressIndicator(color: Colors.blue,),)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
