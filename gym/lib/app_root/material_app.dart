import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/screens/autentiaction_screens/login_screen.dart';
import 'package:gym/screens/autentiaction_screens/register_screen.dart';
import 'package:gym/screens/navigation_Screens/navigation_screen.dart';

import '../core/cubits/authentication_cubit/authentication_cubit.dart';
import '../core/cubits/excercies_cubit/excercies_cubit.dart';




class GymSystem extends StatelessWidget {
  const GymSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationCubit()),
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => ProfileCubit()..reciveAllUserData()),
        BlocProvider(create: (context) => BookingCubit()..getAllAvailableClass()),
        BlocProvider(create: (context) => ExcerciesCubit()..getAllExcercies()
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FirebaseAuth.instance.currentUser == null? LoginScreen() : NavigationScreen(),
      ),
    );
  }
}
