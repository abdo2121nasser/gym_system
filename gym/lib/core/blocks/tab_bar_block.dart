import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:gym/core/cubits/navigation_cubit/navigation_cubit.dart';


class TabBarBlock extends StatelessWidget {
  const TabBarBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationCubit, NavigationState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var navCubit=NavigationCubit.get(context);
        return DefaultTabController(
          length: 2,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
                color: Colors.grey.shade700
            ),
            child: TabBar(
              onTap: (int  index){
                navCubit.changeTabViewScreen(index: index,context: context);
              },
                labelColor: Colors.black87,
                indicatorColor: Colors.deepPurple,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 4,
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                tabs: [
                  Tab(

                      child: Text('Exercises',
                        style: TextStyle(fontSize: navCubit.tabViewIndex==0?25:15),)
                  ),
                   Tab(
                    height: 50,
                    child: Text('Parts',
                    style: TextStyle(fontSize: navCubit.tabViewIndex==1?25:15),),
                  ),
                ]),
          ),
        );
      },
    );
  }
}
