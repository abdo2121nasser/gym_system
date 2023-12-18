import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/constants/constants.dart';
import 'package:gym/core/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:gym/core/models/firebase_models/user_data_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context)=>BlocProvider.of(context);
  TextEditingController name=TextEditingController();
   TextEditingController email=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController address=TextEditingController();
  UserDataModel? userDataModel;
  File? image;
  String imagePath='';
  String emailValidation(String email)
  {
    if( !email.isNotEmpty)
    {
      return 'the email field is empty!!';
    }
    else if(email.contains('@')==false || email.contains('.com')==false || email.contains('gmail')==false)
    {
      return 'email field pattern is wrong';
    }
    else return 'true';
  }

   setControllers()
  async {
     email.text=userDataModel!.email!;
    name.text=userDataModel!.name!;
    phone.text=userDataModel!.phone!;
    address.text=userDataModel!.address!;
    emit(SetControllersState());
  }
  pickImage()
  async {
     emit(PickImageLoadingState());
     await ImagePicker().pickImage(source: ImageSource.gallery)
        .then((value) async {
      image= await  File(value!.path);
      emit(PickImageSuccessState());
    }).catchError((error){
      emit(PickImageErrorState());
      print(error);
     });

  }
  uploadImage()
  async{
    emit(UploadImageLoadingState());
    final ref=FirebaseStorage.instance.ref().child('${image!.path}');
    await ref.putFile(image!).
    then((result) async{

      emit(GetImageUrlLoadingState());
      await result.ref.getDownloadURL()
          .then((value) {
        imagePath=value;
        emit(GetImageUrlSuccessState());
      }).
      catchError((error){
        print(error);
        emit(GetImageUrlErrorState());
      });
      emit(UploadImageSuccessState());
    }).catchError((error){
      emit(UploadImageErrorState());
      print(error);
    });
  }
   // updateEmail(String email)
   // async {
   //   emit(UpdateEmailLoadingState());
   //   AuthCredential credential = EmailAuthProvider.credential(
   //     email: FirebaseAuth.instance.currentUser!.email!,
   //     password: userDataModel!.password!,
   //   );
   //   await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
   //   FirebaseAuth.instance.currentUser!.updateEmail(email).
   //   then((value) {
   //     emit(UpdateEmailSuccessState());
   //   })
   //       .catchError((error){
   //         emit(UpdateEmailErrorState());
   //   });
   // }
 Future<String?> updateProfile()
  async {
    if(image!=null)
      {
       await uploadImage();
      }
    // if(emailValidation(email.text)=='true' && FirebaseAuth.instance.currentUser!.email!=email.text)
    //   updateEmail(email.text);
    emit(UpdateProfileLoadingState());
   await FirebaseFirestore.instance
        .collection(Constants.kUsersCollectionId)
        .doc(userDataModel!.docId)
        .update({
         Constants.kUserName:name.text,
     // if(state is UpdateEmailSuccessState)
     //  Constants.kUserEmail:email.text,
      'phone':phone.text,
      'address':address.text,
      if(imagePath!=null && imagePath.isNotEmpty)
      'image path':imagePath
    }
    )
        .then((value) {
          emit(UpdateProfileSuccessState());

    })
        .catchError((error){
          emit(UpdateProfileErrorState());
          print(error);
    });

  }

  reciveAllUserData()
  async {
    emit(ReciveAllUserDataLoadingState());
   await FirebaseFirestore.instance
        .collection(Constants.kUsersCollectionId).where('email' ,isEqualTo:FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((userData) async{
          userData.docs.forEach((element)  async {
            List<Map<String,dynamic>> temp=[];
            QuerySnapshot<Map<String, dynamic>> subCollection=await element.reference.collection(Constants.kGymClassesHistoryBookingCollectionId).orderBy('start time hour').get();
            subCollection.docs.forEach((sub) {
              temp.add({'data':sub.data(),'subDocId':sub.id});
            });
           userDataModel= await UserDataModel.fromJson(snapshot:await element.data(),mainDocId:await element.id, subCollection:await temp,);
           setControllers();
           //----------------------1
          });
           emit(ReciveAllUserDataSuccessState());
          // print(await userDataModel!.name);
    })
        .catchError((error){
          print(error);
          emit(ReciveAllUserDataErrorState());
    });
   }



}
