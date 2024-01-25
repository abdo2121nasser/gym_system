import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/constants/constants.dart';
import 'package:gym/core/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:gym/core/cubits/book_cubit/booking_cubit.dart';
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
  TextEditingController startCreditController=TextEditingController();
  TextEditingController endCreditController=TextEditingController();
  DateTime startCreditDate=DateTime.now(),endCreditDate=DateTime.now().add(const Duration(days: 1));
  TextEditingController newCreditController=TextEditingController(text: '0');
  TextEditingController currentCreditController=TextEditingController();
  TextEditingController searchUserEmailController=TextEditingController();
  UserDataModel? userDataModel;
     List<UserDataModel> creditUserDataModel=[];
  File? image;
  String imagePath='';
  creditDateValidation({required context})
  async {
   await reciveAllUserData();
    if(userDataModel!=null)
      {
        if(userDataModel!.endCreditDate!.toDate().isBefore(DateTime.now()) && userDataModel!.currentCredit!.toInt()!=0)
        {
          startCreditDate=userDataModel!.startCreditDate!.toDate();
          endCreditDate=userDataModel!.endCreditDate!.toDate();
          currentCreditController.text='0';
          newCreditController.text='0';
          searchUserEmailController.text=userDataModel!.email!;
          emit(CreditDateValidationState());
          await getCreditUserData(context: context);
          await updateCredit(context: context);

        }
      }

  }

  getCreditUserData({required context})
  async {
    creditUserDataModel.clear();
    emit(GetCreditUserDataLoadingState());
    await FirebaseFirestore.instance
        .collection(Constants.kUsersCollectionId).where('email' ,isEqualTo:searchUserEmailController.text)
        .get()
        .then((value) {
          print('-----------------------------------');
         print(value.docs[0].data());
      creditUserDataModel.add(UserDataModel.fromJson(snapshot: value.docs[0].data(), mainDocId: value.docs[0].id,));
      currentCreditController!.text=creditUserDataModel[0].currentCredit!.toString();
      startCreditController.text='${creditUserDataModel[0].startCreditDate!.toDate().year}/${creditUserDataModel[0].startCreditDate!.toDate().month}/${creditUserDataModel[0].startCreditDate!.toDate().day}';
      endCreditController.text='${creditUserDataModel[0].endCreditDate!.toDate().year}/${creditUserDataModel[0].endCreditDate!.toDate().month}/${creditUserDataModel[0].endCreditDate!.toDate().day}';
      emit(GetCreditUserDataSuccessState());
    })
        .catchError((error){
      emit(GetCreditUserDataErrorState());
      print(error);
      if(error.toString()!='Null check operator used on a null value') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('error has happened check the email might be in correct')));
      }

    });
  }

  updateCredit({required context})
  async {
    // await getCreditUserData(context: context);
    emit(UpdateCreditLoadingState());
    await FirebaseFirestore.instance
        .collection(Constants.kUsersCollectionId)
        .doc(creditUserDataModel[0].docId)
        .update({
      'start credit date':Timestamp.fromDate(startCreditDate),
      'end credit date':Timestamp.fromDate(endCreditDate),
      'current credit':int.parse(newCreditController.text),
      'package size':int.parse(newCreditController.text)
    }).
    then((value) {
      emit(UpdateCreditSuccessState());
      searchUserEmailController.text=creditUserDataModel[0].email!;
      newCreditController.text='';

      getCreditUserData(context: context);
      searchUserEmailController.clear();
    })
        .catchError((error){
      emit(UpdateCreditErrorState());
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('something went wrong!!')));

    });
  }
 

  setCreditDate({required bool isStartTime,required DateTime tTime})
  {
    if(isStartTime)
    {
      startCreditDate=tTime;
      startCreditController.text='${tTime.year.toString()}/${tTime.month
          .toString()}/${tTime.day.toString()}';
      emit(SetStartCreditState());
    }
    else
    {
      endCreditDate=tTime;
      endCreditController.text='${tTime.year.toString()}/${tTime.month
          .toString()}/${tTime.day.toString()}';
      emit(SetEndCreditState());
    }
    if(endCreditDate.isBefore(startCreditDate))
    {
      endCreditDate=startCreditDate.add(const Duration(days: 1));
      endCreditController.text='${endCreditDate.year.toString()}/${endCreditDate.month
          .toString()}/${endCreditDate.day.toString()}';
    }


  }

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
   // currentCreditController!.text=userDataModel!.currentCredit!.toString();
       image=null;
       imagePath='';
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
 Future<String?> updateProfile({required context})
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
      if(imagePath !=null && imagePath.isNotEmpty)
      Constants.kUserImageUrl:imagePath.toString()
    }
    )
        .then((value) async {
         await reciveAllUserData();
          emit(UpdateProfileSuccessState());
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Success Update')));

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
           await setControllers();
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

  incrementCredit({required int currentCredit1,required String docId})
  async {
   // await reciveAllUserData();
    emit(IncrementCreditLoadingState());
   await FirebaseFirestore.instance
        .collection(Constants.kUsersCollectionId)
        .doc(docId)
        .update({
      'current credit':/*userDataModel!.currentCredit!+1*/currentCredit1
    }).
    then((value) {
      emit(IncrementCreditSuccessState());
    })
        .catchError((error){
      emit(IncrementCreditErrorState());

        print(error.toString());

    });
  }

  decrementCredit()
  async{
emit(DecrementCreditLoadingState());
   await FirebaseFirestore.instance
        .collection(Constants.kUsersCollectionId)
        .doc(userDataModel!.docId)
        .update({
      'current credit':await userDataModel!.currentCredit!-1
        }).
    then((value) {
      emit(DecrementCreditSuccessState());
    })
        .catchError((error){
      emit(DecrementCreditErrorState());
      print(error.toString());

    });
  }




}
