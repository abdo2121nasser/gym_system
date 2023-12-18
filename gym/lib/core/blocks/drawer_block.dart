import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/constants/constants.dart';
import 'package:gym/core/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:gym/core/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/screens/class_history_screen.dart';
import 'package:gym/screens/edit_customer_profile_screen.dart';
import '../../screens/autentiaction_screens/forget_password.dart';
import '../../screens/autentiaction_screens/login_screen.dart';
import '../cubits/authentication_cubit/authentication_cubit.dart';



class DrawerBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    return BlocConsumer<NavigationCubit, NavigationState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
  listener: (context, state) {
  },
  builder: (context, state) {
    var authCubit=AuthenticationCubit.get(context);
    var navCubit=NavigationCubit.get(context);
    var profCubit=ProfileCubit.get(context);
    return Drawer(
       child: profCubit.userDataModel != null?
       ListView(
         physics: const BouncingScrollPhysics(),
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Padding(
               padding: const EdgeInsets.only(bottom: 5),
               child: profCubit.userDataModel!=null?
               CircleAvatar(
                   radius: 35,
                   backgroundImage: Image.network(profCubit.userDataModel!.imageUrl!,).image)
               : const CircularProgressIndicator(color: Colors.white,),
             ),
            Row(
              children: [
                profCubit.userDataModel!=null?
                Expanded(
                  flex: 1,
                  child: Text(profCubit.userDataModel!.name!,
                    style:const TextStyle(
                      color: Colors.white,fontSize:20,fontWeight: FontWeight.bold
                    ),),
                ):CircularProgressIndicator(color: Colors.white,),
              ],
            ),const SizedBox(height: 5,),
             Row(
               children: [
                 profCubit.userDataModel!=null?
                 Expanded(
                   flex:1 ,
                   child: Text(profCubit.userDataModel!.email!,
                     style:const TextStyle(
                       color: Colors.white,fontSize:16,
                     ),),
                 ):CircularProgressIndicator(color: Colors.white,),
               ],
             ),
           ],
                )
            ),
            ListTile(

              leading: const Icon(
                Icons.history_edu_outlined,
                color: Colors.grey,
              ),
              title: const Text('Class History',
              style: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.bold),),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ClassHistoryScreen(),));
              },
            ),
           const Divider(thickness: 2,endIndent: 20,indent: 20,),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.grey,
              ),
              title: const Text('Edit Profile',
    style: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.bold),),
              onTap: () {
               navCubit.changeScreenIndex(screenIndex1: 4,context: context);
               Scaffold.of(context).closeDrawer();
              },
            ),
            const Divider(thickness: 2,endIndent: 20,indent: 20,),
            ListTile(

              leading: const Icon(
                Icons.change_circle_outlined,
                color: Colors.grey,
              ),
              title: const Text('Change Password',
                style: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.bold),),
              onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) =>  ForgetPasswordScreen(),));
              },
            ),
            const Divider(thickness: 2,endIndent: 20,indent: 20,),
            if(profCubit.userDataModel!.priority=='1')
            Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.attach_money_outlined,
                    color: Colors.teal,
                  ),
                  title: const Text('Credit',
                    style: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.bold),),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditCustomerCreditScreen(),));
                  },
                ),
                const Divider(thickness: 2,endIndent: 20,indent: 20,),
              ],
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text('LogOut',
                style: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.bold),),
              onTap: () async {
              String massage= await authCubit.logout(context: context);
              Scaffold.of(context).closeDrawer();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: await massage=='true'?const Text('successful logout')
                    :const Text('oops!!\nthere was a problem'),
              ));
              if(await massage=='true')
              {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
                }
              },
            ),
          ],
        ): const Center(child: CircularProgressIndicator(color: Colors.blue,))
    );
  },
);
  },
);
  },
);
  }
}
