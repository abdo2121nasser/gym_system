import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/blocks/general_button_block.dart';
import 'package:gym/core/blocks/general_text_field_block.dart';
import 'package:gym/core/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:gym/core/cubits/authentication_cubit/authentication_cubit.dart';


class ChangeRegistrationCodeScreen extends StatelessWidget {
  const ChangeRegistrationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var authCubit=AuthenticationCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: const Text('Change Registration Code',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
          ),
          body: authCubit.ownerRegistrationCodeController.text!=''|| authCubit.couchRegistrationCodeController.text!=''?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GeneralTextFieldBlock(hint: 'Owner Code', controller: authCubit.ownerRegistrationCodeController),
                const SizedBox(height: 20,),
                GeneralTextFieldBlock(hint: 'Couch Code', controller: authCubit.couchRegistrationCodeController),
                const SizedBox(height: 20,),
               GeneralButtonBlock(
                   lable:'Update',
                   function: (){
                     authCubit.updateRegistrationCode(context: context);
                   },
                   width:double.maxFinite, hight: 50,
                   textColor: Colors.white, backgroundColor: Colors.blue,
                   borderRadius:10
               ),
                if(state is UpdateRegistrationCodesLoadingState) Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const CircularProgressIndicator(color: Colors.blue,),
                ),
              ],
            ),
          )
              :
          Center(
            child: CircularProgressIndicator(color: Colors.blue,),
          ),
        );
      },
    );
  }
}
