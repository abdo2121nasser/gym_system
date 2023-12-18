import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/blocks/general_button_block.dart';
import 'package:gym/core/blocks/general_text_field_block.dart';
import 'package:gym/core/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:gym/core/cubits/authentication_cubit/authentication_cubit.dart';


class ForgetPasswordScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var authData=AuthenticationCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('enter your email',
                    style: TextStyle(fontSize: 20),),
                 const  SizedBox(height: 20,),
                  GeneralTextFieldBlock(
                      hint: 'Email', controller: authData.forgetPasswordEmail),
                  const  SizedBox(height: 20,),

                  GeneralButtonBlock(
                    lable: 'reset password',
                    function: () async {
                      String massege= await authData.forgetPassword( authData.forgetPasswordEmail.text);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: await massege=='true'?const Text('we sent reset email for you to reset your password')
                            :const Text('oops!!\nthere was a problem'),
                      ));
                      if( state is ForgetPasswordSucssedState) Navigator.pop(context);
                    },
                    width: double.maxFinite,hight: 50,
                    textColor: Colors.white,backgroundColor: Colors.blue,
                    borderRadius: 20,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
