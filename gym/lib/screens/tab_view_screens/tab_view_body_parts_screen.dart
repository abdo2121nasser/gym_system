import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/blocks/body_part_block.dart';
import 'package:gym/screens/other_screens/show_list_of_body_parts_screen.dart';
import 'package:gym/core/constants/constants.dart';
import 'package:gym/core/cubits/excercies_cubit/excercies_cubit.dart';



class TabViewBodyPartsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExcerciesCubit, ExcerciesState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    var exCubit=ExcerciesCubit.get(context);
    return Container(
      height: 418,
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20,),
                itemBuilder: (context, index) =>InkWell(
                  onTap: () async {
                   await exCubit.getBodyPartExcercies(bodyPartName: exCubit.bodyParts[index],);
                   await Navigator.push(context, MaterialPageRoute(builder: (context) => ShowListOfBodyPartsScreen(bodyPartName:exCubit.bodyParts[index] ,),));
                  },
                  child: ItemsBlock(
                    name: exCubit.bodyParts[index],image: exCubit.bodyPartsImages[index],),
                ),
                separatorBuilder: (context, index) =>
                const SizedBox(height: 10,),
                itemCount: exCubit.bodyParts.length),
          )
        ],
      ),
    );
  },
);
  }
}
