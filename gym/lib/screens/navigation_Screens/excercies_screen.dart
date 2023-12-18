import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:gym/core/cubits/navigation_cubit/navigation_cubit.dart';

import '../../core/blocks/tab_bar_block.dart';


class ExcerciesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationCubit, NavigationState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var navCubit=NavigationCubit.get(context);
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
                   color: Colors.white,
            child: Column(
              children: [
                TabBarBlock(),
                SizedBox(height: 10,),
                       navCubit.currentTabViewScreen
              ],
            ),
          ),
        );
      },
    );
  }
}