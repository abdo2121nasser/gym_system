import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/blocks/drawer_block.dart';
import 'package:gym/core/constants/constants.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
import 'package:gym/core/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:gym/core/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';




class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    return BlocConsumer<ProfileCubit, ProfileState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    return BlocConsumer<NavigationCubit, NavigationState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    var navCubit= NavigationCubit.get(context);
    var profCubit=ProfileCubit.get(context);
    var bCubit=BookingCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 60,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Builder(
            builder: (context) => InkWell(
              child: Image.asset(
                Constants.kImageDrawer,cacheHeight: 30,cacheWidth: 30,),
              onTap: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5,),
                  SizedBox(
                    width: 220,
                    child: Row(
                      children: [
                        profCubit.userDataModel!=null?
                        Expanded(
                          child: Text('Hi, ${profCubit.userDataModel!.name}',
                            style:const TextStyle(
                                color: Colors.black,fontSize:25, fontWeight: FontWeight.bold
                            ),),
                        )
                            : const CircularProgressIndicator(color: Colors.blue,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  const Text('Have a Nice Training',
                    style:TextStyle(
                      color: Colors.grey,fontSize:15,
                    ),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: profCubit.userDataModel!=null?
                CircleAvatar(
                    radius: 23,
                    backgroundImage: Image.network(profCubit.userDataModel!.imageUrl!,).image)
                    : const CircularProgressIndicator(),
              )
            ],
          ),
        ),
      drawer: DrawerBlock(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey.shade700,
        onTap: (newIndex) => navCubit.changeScreenIndex(screenIndex1: newIndex,context: context),
        currentIndex:navCubit.screenIndex,
      backgroundColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
          BottomNavigationBarItem(icon: Icon(Icons.accessibility_outlined), label:'Exercises'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
                 floatingActionButton:
                profCubit.userDataModel!=null?
                navCubit.screenIndex==1 && profCubit.userDataModel!.priority=='1'?
                FloatingActionButton(
                  backgroundColor: Colors.indigo.shade400,
                  onPressed: () {
                    if(bCubit.selectedDay.isAfter(DateTime.now())) {
                      bCubit.showDialogBox(context: context);
                      // todo remove the or in condition
                    } else
                      {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 2),
                            content: const Text('sorry but you can not add class before current date')

                    ));
                      }
                  },
                  shape: CircleBorder(),
                  child: Icon(Icons.add,size: 30,color: Colors.white,),

                ):
                null :null,
               body: navCubit.currentScreen

    );
  },
);
  },
);
  },
);
  }
}
