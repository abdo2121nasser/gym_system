import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/screens/autentiaction_screens/login_screen.dart';
import '../../screens/autentiaction_screens/register_screen.dart';
import '../cubits/authentication_cubit/authentication_cubit.dart';



class AuthSwitchBlock extends StatelessWidget {
  const AuthSwitchBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    var authData=AuthenticationCubit.get(context);
    return authData.authScreenSwitch?
    Container(
      margin:const EdgeInsets.only(left: 30,right: 30,bottom: 20),
     height: 60,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.black,width: 1,)
  ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 150,height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black,width: 1,)
            ),
            child: const Text('LOGIN',
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),),
          ), Padding(
            padding: const EdgeInsets.only(left: 28),
            child: InkWell(onTap: (){
              authData.changAuthScreenSwitch('SignUp');
            },
              child: InkWell(
                onTap: (){
                    authData.clearControllers();
                    authData.changAuthScreenSwitch('Register');
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));

                },
                child: const Text('SIGN UP',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey),),
              ),
            ),
          )
        ],
      ),
    )
        :
    Container(
      margin:const EdgeInsets.only(left: 30,right: 30,bottom: 20),
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black,width: 1,)
      ),
      child: Row(
        children: [
          Padding(
    padding: const EdgeInsets.only(left: 40,right: 50),
    child: InkWell(
      onTap:(){
          authData.changAuthScreenSwitch('Login');
          authData.clearControllers();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));


      },
      child: const Text('LOGIN',
      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey),),
    ),
    ),
           Container(
            alignment: Alignment.center,
            width: 149,height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black,width: 1,)
            ),
            child: const Text('SIGN UP',
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),),
          )
        ],
      ),
    );
  },
);
  }
}
