import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/excercies_cubit/excercies_cubit.dart';
import 'package:gym/screens/navigation_Screens/excercies_screen.dart';
import 'package:gym/screens/tab_view_screens/tab_view_body_parts_screen.dart';
import 'package:gym/screens/tab_view_screens/tab_view_excercies_screen.dart';
import 'package:meta/meta.dart';

import '../../../screens/navigation_Screens/book_screen.dart';
import '../../../screens/navigation_Screens/home_screen.dart';
import '../../../screens/navigation_Screens/profle_screen.dart';
import '../profile_cubit/profile_cubit.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitial());
  static NavigationCubit get(context)=>BlocProvider.of(context);
  List<Widget>screens=[
    const HomeScreen(),
    BookScreen(),
    ExcerciesScreen(),
    ProfileScreen()
  ];
  int screenIndex=0;
 late Widget currentScreen=screens[screenIndex];
 List <Widget> tabViewContainers=[TabViewExcerciestScreen(),TabViewBodyPartsScreen()];
 late Widget currentTabViewScreen=tabViewContainers[tabViewIndex];
   int tabViewIndex=0;
  Future<void> changeScreenIndex({required int screenIndex1 ,bool loginState=false,required context})
  async {

    if(BookingCubit.get(context).classInProgress.contains(true)!=false)
    {
      await ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('there is booking Process is in Process now you can not interrupt it'),duration: Duration(seconds: 1),));
      return;
    }
    if(BookingCubit.get(context).classInDeleting.contains(true)!=false)
    {
      await ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('there is deleting Process is in Process now you can not interrupt it'),duration: Duration(seconds: 1),));
      return;
    }

    this.screenIndex=screenIndex1;
        currentScreen=screens[screenIndex];
        if(screenIndex==2) {
          tabViewIndex=0;
          currentTabViewScreen=tabViewContainers[tabViewIndex];
        }
        if(screenIndex==1)
          {
            BookingCubit.get(context).changeSelectedDay(DateTime.now(),context);
           //await BookingCubit.get(context).getHistroyGymClasses(context: context);
          }
        if(screenIndex==0 && loginState ==false)
          {
            Future.delayed(const Duration(seconds: 0)).then((value) async {
             await ProfileCubit.get(context).reciveAllUserData();
            }).then((value) async {
             await BookingCubit.get(context).getRecentBookedClasses(context: context);

            }).catchError((error){
              print(error);
            });

          }

       emit(ChangeScreenIndexState());
  }

  void changeTabViewScreen({required int index,context})
  {
    tabViewIndex=index;
    currentTabViewScreen=tabViewContainers[tabViewIndex];
    if(tabViewIndex==0)
      {
        ExcerciesCubit.get(context).getAllExcercies();
      }
    emit(ChangeTabViewScreenIndexState());
  }

}
