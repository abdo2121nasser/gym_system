import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/bloc_observer/search_bar_block.dart';
import 'package:gym/core/blocks/show_gif_block.dart';
import 'package:gym/core/cubits/excercies_cubit/excercies_cubit.dart';
import 'package:gym/core/cubits/excercies_cubit/excercies_cubit.dart';

import '../../core/models/api_models/excercies_model.dart';
import 'detail_excercies_screen.dart';


class ShowListOfBodyPartsScreen extends StatelessWidget {
final  String bodyPartName;

ShowListOfBodyPartsScreen({required this.bodyPartName,});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExcerciesCubit, ExcerciesState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var exCubit=ExcerciesCubit.get(context);
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(bodyPartName.toUpperCase(),
              style: const TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
              backgroundColor: Colors.blue,
              leading: IconButton(onPressed: (){
                Navigator.pop(context);
              },icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,),),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const SizedBox(height: 10),
                exCubit.bodyPartModel!=null?
                Expanded(
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20,),
                      itemBuilder: (context, index)
                          {
                           return InkWell(
                               onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => DetailExcerciesScreen(excercie: exCubit.bodyPartModel!.excercies![index]),));
                               },
                               child: ShowGifBlock(name:  exCubit.bodyPartModel!.excercies![index].name!, gifUrl:  exCubit.bodyPartModel!.excercies![index].gifUrl!));},
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 10,),
                      itemCount: exCubit.bodyPartModel!.excercies!.length!),
                ):
                Center(child: const CircularProgressIndicator(color: Colors.blue,)),
              ],
            )
        );
      },
    );
  }
}
