import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/screens/autentiaction_screens/login_screen.dart';
import 'package:gym/screens/navigation_Screens/navigation_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds:FirebaseAuth.instance.currentUser == null?2:0),).then((value) async {
      FirebaseAuth.instance.currentUser == null?
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),))
          : await ProfileCubit.get(context).reciveAllUserData();

    }).catchError((error){
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if(state is ReciveAllUserDataSuccessState) {
          Future.delayed(const Duration(seconds: 2),() {
          return  Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const NavigationScreen(),));
          },);

        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('lib/core/assets/weight.png',
                  width: 300, height: 300,),
                const CircularProgressIndicator(color: Colors.blue,)
              ],
            ),
          ),
        );
      },
    );
  }
}
