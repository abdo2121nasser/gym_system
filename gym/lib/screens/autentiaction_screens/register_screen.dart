import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/screens/autentiaction_screens/login_screen.dart';
import '../../core/blocks/auth_switch_block.dart';
import '../../core/blocks/general_button_block.dart';
import '../../core/blocks/general_text_field_block.dart';
import '../../core/cubits/authentication_cubit/authentication_cubit.dart';




class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var authData=AuthenticationCubit.get(context);
        return Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: SizedBox(
              height: 690,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 40,bottom: 5),
                    child: Text('Gym System',style: TextStyle(
                        fontSize: 40,
                        color: Colors.blue
                    ),),
                  ),
                  const AuthSwitchBlock(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      height: 320,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Create Account',
                            style: TextStyle(fontSize: 25,color: Colors.blue),),
                          GeneralTextFieldBlock(hint: 'Name', controller: authData.registerName,),
                          GeneralTextFieldBlock(hint: 'Email', controller: authData.registerEmail,),
                          GeneralTextFieldBlock(hint: 'Password', controller: authData.registerPassword,),
                          GeneralTextFieldBlock(hint: 'Confirm Password', controller: authData.registerConfirmPassword,),
            
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Checkbox(value: authData.registerKindIndex==0?true:false,
                              onChanged: (value){
                                authData.changeCheckBoxValue(index: 0, value: value!);
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            const Text('Customer',
                              style:TextStyle(fontSize: 20),),

                          ]
                          ,),
                        SizedBox(width: 10,),
                        Row(
                            children: [
                              Checkbox(value: authData.registerKindIndex==1?true:false,
                                onChanged: (value){
                                  authData.changeCheckBoxValue(index: 1, value: value!);
                              },
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              const Text('Couch',
                                style:TextStyle(fontSize: 20),),

                            ]
                            ,),
            
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(value: authData.registerKindIndex==2?true:false,
                          onChanged: (value){
                          print(value);
                          authData.changeCheckBoxValue(index: 2, value: value!);
                           },
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        const Text('Owner',
                          style:TextStyle(fontSize: 20),),

                      ]
                      ,),
                  ],
                ),
            
                  Padding(
                    padding: const EdgeInsets.only(left: 40,right: 40,bottom: 10),
                    child: GeneralButtonBlock(lable: 'Sign Up',borderRadius: 20,
                        function: () async {
                      var massage= await authData.register();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: await massage=='true'?const Text('successful register')
                              : Text('${massage}'),
                          ));
                      print(massage);
                      if(await massage=='true')
                        {
                          authData.changAuthScreenSwitch('Login');
                         Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => LoginScreen(),));
                        }
                        }, width: double.maxFinite,
                        hight: 45, textColor: Colors.white, backgroundColor: Colors.blue),
                  ),
                  if(state is RegisterLoadingState)const CircularProgressIndicator(color: Colors.blue,),
                  const Spacer()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
