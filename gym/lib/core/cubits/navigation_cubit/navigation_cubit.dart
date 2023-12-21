import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/cubits/excercies_cubit/excercies_cubit.dart';
import 'package:gym/screens/navigation_Screens/excercies_screen.dart';
import 'package:gym/screens/navigation_Screens/progress_screen.dart';
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
    HomeScreen(),
    BookScreen(),
    ExcerciesScreen(),
    ProgressScreen(),
    ProfileScreen()
  ];
  int screenIndex=0;
 late Widget currentScreen=screens[screenIndex];
 List <Widget> tabViewContainers=[TabViewExcerciestScreen(),TabViewBodyPartsScreen()];
 late Widget currentTabViewScreen=tabViewContainers[tabViewIndex];
   int tabViewIndex=0;
  void changeScreenIndex({required int screenIndex1 ,required context})
  {
       this.screenIndex=screenIndex1;
        currentScreen=screens[screenIndex];
        if(screenIndex==2) {
          tabViewIndex=0;
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
