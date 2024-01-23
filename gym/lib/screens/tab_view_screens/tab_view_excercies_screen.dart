import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/bloc_observer/search_bar_block.dart';
import 'package:gym/core/blocks/show_gif_block.dart';
import 'package:gym/core/cubits/excercies_cubit/excercies_cubit.dart';
import 'package:gym/core/cubits/excercies_cubit/excercies_cubit.dart';

import '../other_screens/detail_excercies_screen.dart';


class TabViewExcerciestScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExcerciesCubit, ExcerciesState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var exCubit=ExcerciesCubit.get(context);
        return Container(
          height: 470,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [

              exCubit.searchController.text.isNotEmpty?   Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: SearchBarBlock(
                                  controller: exCubit.searchController, function: () async {
                                exCubit.excerciesModel=null;
                                exCubit.searchGeneralExcercies();
                                if(exCubit.excerciesModel==null)
                                {
                                  await Future.delayed(const Duration(seconds: 2));
                                }
                              }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: (){
                                exCubit.searchController.clear();
                                exCubit.getAllExcercies();
                              },
                              child: Text('Cancel',
                                style: TextStyle(color: Colors.blue,fontSize: 20,decoration: TextDecoration.underline),),
                            ),
                          )
                        ],
                      ):
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 10),
                child: SearchBarBlock(
                    controller: exCubit.searchController, function: () async {
                      exCubit.excerciesModel=null;
                      exCubit.searchGeneralExcercies();
                      if(exCubit.excerciesModel==null)
                        {
                         await Future.delayed(const Duration(seconds: 2));
                        }
                }),
              ),
             exCubit.excerciesModel!=null?
             exCubit.excerciesModel!.excercies!.isEmpty?
                 const Center(child: Padding(
                   padding: EdgeInsets.symmetric(horizontal:10),
                   child: Text('there is no exercises with this name',
                   style: TextStyle(fontSize: 30),),
                 ),)
                 :
             Expanded(
               child: ListView.separated(
                   physics: const BouncingScrollPhysics(),
                   padding: const EdgeInsets.symmetric(horizontal: 20,),
                   itemBuilder: (context, index) {
                     return InkWell(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context) => DetailExcerciesScreen(excercie: exCubit.excerciesModel!.excercies![index]),));
                       },
                       child: ShowGifBlock(
                         gifUrl: exCubit.excerciesModel!.excercies![index].gifUrl!,name:exCubit.excerciesModel!.excercies![index].name! ,),
                     );
                   },
                   separatorBuilder: (context, index) =>
                   const SizedBox(height: 10,),
                   itemCount: exCubit.excerciesModel!.excercies!.length!),
             ):
             const Padding(
               padding: EdgeInsets.only(top: 20),
               child: Center(child: CircularProgressIndicator(color: Colors.blue,),),
             )
            ],
          ),
        );
      },
    );
  }
}
