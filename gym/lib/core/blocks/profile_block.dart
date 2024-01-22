import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/blocks/general_text_field_block.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';


class ProfileBlock extends StatelessWidget {
  const ProfileBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        var profCubit=ProfileCubit.get(context);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20)
          ),
          child: Column(children: [
            GeneralTextFieldBlock(
              hint: 'name', controller: profCubit.name,
              preIcon: const Icon(Icons.person, color: Colors.blueAccent,),
              hintColor: Colors.black,),
            const SizedBox(height: 15,),
            GeneralTextFieldBlock(canEdit: false,
              hint: 'email', controller: profCubit.email,
              preIcon: const Icon(Icons.email, color: Colors.blueAccent,),
              hintColor: Colors.black,),
            const SizedBox(height: 15,),
            GeneralTextFieldBlock(
              hint: 'phone', controller: profCubit.phone,onlyInteger: true,
              preIcon: const Icon(Icons.phone, color: Colors.blueAccent),
              hintColor: Colors.black,),
            const SizedBox(height: 15,),
            GeneralTextFieldBlock(
              hint: 'address', controller:profCubit.address,
              preIcon: const Icon(
                  Icons.location_on_sharp, color: Colors.blueAccent),
              hintColor: Colors.black,),
          ],
          ),
        );
      },
    );
  }
}
