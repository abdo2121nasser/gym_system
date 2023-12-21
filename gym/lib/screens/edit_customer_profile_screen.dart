import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/bloc_observer/search_bar_block.dart';
import 'package:gym/core/blocks/general_button_block.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';

import '../core/blocks/general_text_field_block.dart';


class EditCustomerCreditScreen extends StatefulWidget {

  @override
  State<EditCustomerCreditScreen> createState() => _EditCustomerCreditScreenState();
}

class _EditCustomerCreditScreenState extends State<EditCustomerCreditScreen> {
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
            //physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
              child: Column(
                children: [
                  profCubit.creditUserDataModel.isEmpty?
                  SearchBarBlock(
                      controller: profCubit.searchUserEmailController, function: () async {
                      await  profCubit.getCreditUserData(context: context);
                      profCubit.searchUserEmailController.clear();
                  }):
                  Row(
                    children: [
                      Expanded(
                        child: SearchBarBlock(
                            controller: TextEditingController(), function: () {}),
                      ),InkWell(
                        onTap: ()
                        {
                          profCubit.creditUserDataModel.clear();
                          setState(() {
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Text('Cancel',style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,fontSize: 20
                          ),),
                        ),
                      )
                    ],
                  ),
                  profCubit.creditUserDataModel.isNotEmpty?
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
                  Image.network(profCubit.creditUserDataModel[0].imageUrl!).image

                  )
                  ),

                  ),
                  Text(profCubit.userDataModel!.name!,
                  style: TextStyle(fontSize: 30),),
                                 const SizedBox(height: 10,),
                  GeneralTextFieldBlock(hint: 'current credit', controller: profCubit.currentCreditController!,canEdit: false,),
                    const SizedBox(height: 10,),
                    GeneralTextFieldBlock(hint: 'new credit', controller: profCubit.newCreditController,onlyInteger: true,),
                    const SizedBox(height: 10,),
                    GeneralTextFieldBlock(hint: 'start credit date', controller:profCubit.startCreditController,canEdit: false,suffixIcon: Icon(Icons.timer_outlined),isStartTime: true),
                    const SizedBox(height: 10,),
                    GeneralTextFieldBlock(hint: 'end credit date', controller:profCubit.endCreditController,canEdit: false,suffixIcon: Icon(Icons.timer_off_outlined),isStartTime: false,),
                    const SizedBox(height: 10,),
                    GeneralButtonBlock(
                        lable: 'Update', function: (){
                          profCubit.updateCredit(context: context);
                    },
                        width: double.maxFinite, hight: 50,
                        textColor: Colors.white, backgroundColor: Colors.blue,
                        borderRadius: 10)
                       ]
                  )

                      :Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Text('search on user by his email',
                                        style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    ),)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
