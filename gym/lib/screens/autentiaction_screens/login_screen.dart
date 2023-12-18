import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:gym/core/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:gym/screens/autentiaction_screens/forget_password.dart';
import 'package:gym/screens/navigation_Screens/navigation_screen.dart';
import '../../core/blocks/auth_switch_block.dart';
import '../../core/blocks/general_button_block.dart';
import '../../core/blocks/general_text_field_block.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    var authData=AuthenticationCubit.get(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 60,bottom: 30),
            child: Text('Gym System',style: TextStyle(
                fontSize: 40,
                color: Colors.blue
            ),),
          ),
          const AuthSwitchBlock(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GeneralTextFieldBlock( hint: 'Email', controller: authData.loginEmail,),
                  GeneralTextFieldBlock( hint: 'Password', controller: authData.loginPassword,),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordScreen(),));
                          },
                          child:  Text('Forget Password?',
                            style: TextStyle(color: Colors.grey.shade600,fontSize: 15,decoration: TextDecoration.underline),),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 40,right: 40,bottom: 10),
            child: GeneralButtonBlock(lable: 'Login',borderRadius: 20,
                function: () async {
                  String massage= await authData.login( context:context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: await massage=='true'?const Text('successful login')
                          : Text('${massage}'),
                  ));
                  if(await massage=='true') {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavigationScreen(),));
                  }
                }, width: double.maxFinite,
                hight: 45, textColor: Colors.white, backgroundColor: Colors.blue),
          ),
          if(state is LoginLoadingState)const CircularProgressIndicator(color: Colors.blue,),
          const Spacer()
        ],
      ),
    );
  },
);
  }
}
