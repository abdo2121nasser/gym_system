import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/cubits/excercies_cubit/excercies_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:meta/meta.dart';

import '../../constants/constants.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());
  static AuthenticationCubit get(context) =>BlocProvider.of(context);
  bool authScreenSwitch=true;
  TextEditingController loginEmail=TextEditingController();
  TextEditingController loginPassword=TextEditingController();
  TextEditingController registerEmail=TextEditingController();
  TextEditingController registerName=TextEditingController();
  TextEditingController registerPassword=TextEditingController();
  TextEditingController registerConfirmPassword=TextEditingController();
  TextEditingController forgetPasswordEmail=TextEditingController();
  TextEditingController registerCodeController=TextEditingController(text: '');
  TextEditingController couchRegistrationCodeController=TextEditingController(text: '');
  TextEditingController ownerRegistrationCodeController=TextEditingController(text: '');

  List<String> registerKind=['Customer','Couch','Owner'];
  List<String> registerPriority=['3','2','1'];
  int registerKindIndex=0;
  bool verifiedEmail= false;
   changeCheckBoxValue({required int index, required bool value})
   {
     if(value==true) {
       registerKindIndex=index;
       emit(ChangeCheckBoxValueState());
     }
   }
   changAuthScreenSwitch(String text)
  {
    if(text=='Login') {
      authScreenSwitch=true;
      emit(ChangeToLogInScreenState());
    } else
      {
        authScreenSwitch=false;
        emit(ChangeToSignUpScreenState());
      }
  }
   clearControllers()
   {
     loginEmail.clear();
     loginPassword.clear();
     registerName.clear();
     registerEmail.clear();
     registerPassword.clear();
     registerConfirmPassword.clear();
     emit(ClearControllersState());
   }
 String nameValidation(String name)
  {
    if( !registerName.text.isNotEmpty)
    {
      return 'the name field is empty!!';
    }
    else if(registerName.text.contains(RegExp(r'[0-9]')))
    {
      return 'name field should not contain numbers';
    }
    else return 'true';
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
 String passwordValidation(String password)
  {
    if( !password.isNotEmpty)
    {
      return 'the passsword field is empty!!';
    }
    else if(password.length < 8)
    {
      print(password.length);
      return 'password should be at least 8 numbers or characters';
    }
    else return 'true';
  }
   String registerValidation()
    {
     if(nameValidation(registerName.text)!='true')
       {
         return nameValidation(registerName.text);
       }
     else if(emailValidation(registerEmail.text)!='true')
       {
         return emailValidation(registerEmail.text);
       }
     else if(passwordValidation(registerPassword.text)!='true')
       {
         return passwordValidation(registerPassword.text);
       }
     else if (registerPassword.text!=registerConfirmPassword.text)
       {
         return 'password field is not equal confirmation password field';
       }
     else if(registerCodeController.text=='' && registerKindIndex!=0)
       {
         return 'the registration code field is empty!';
       }
     else
       {
        return 'true';
       }
   }
String loginValidation()
{
   if(emailValidation(loginEmail.text)!='true')
  {
  return emailValidation(loginEmail.text);
  }
   else if(passwordValidation(loginPassword.text)!='true')
   {
     return passwordValidation(loginPassword.text);
   }
   else {
     return 'true';
   }
}


  Future<String> register()
  async {
    String massege= registerValidation().toString();
    if(massege !='true') return massege;
    emit(RegisterLoadingState());
   await getRegistrationCode();
   if(registerKindIndex==1)
     {
       if(registerCodeController.text!=couchRegistrationCodeController.text)
         {
           return 'The Code Is Wrong';
         }
     }
   else if(registerKindIndex==2)
     {
       if(registerCodeController.text!=ownerRegistrationCodeController.text)
       {
         return 'The Code Is Wrong';
       }
     }
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: registerEmail.text,
      password: registerPassword.text,
    ).then((value)
    async {
     await registerationSaveData();
      clearControllers();
      emit(RegisterSucssedState());
    }).catchError((error)
    {
      clearControllers();
      emit(RegisterErrorState());
      print(error);
    });

    return state is RegisterSucssedState ? 'true' : 'registration failed';
  }

  Future<void> registerationSaveData()
  async {
    emit(RegistrationSaveDataLoadingState());
    CollectionReference data = FirebaseFirestore.instance.collection(Constants.kUsersCollectionId);
    // open messages to communicat with captin and add history
    await data.add({
      Constants.kUserName:registerName.text,
      Constants.kUserEmail:registerEmail.text,
      Constants.kUserPassword:registerPassword.text,
      Constants.kUserKind:registerKind[registerKindIndex],
      Constants.kUserPriority:registerPriority[registerKindIndex],
      'address':'',
      'phone':'011',
      'current credit':0,
      'package size':0,
      'start credit date':Timestamp.fromDate(DateTime.now()),
      'end credit date':Timestamp.fromDate(DateTime.now().add(Duration(days: 1))),
      Constants.kUserImageUrl:Constants.kUserInitialimage,
    })
        .then((value) {
      emit(RegistrationSaveDataSucssedState());
    })
        .catchError((error){
      emit(RegistrationSaveDataErrorState());
      print(error);
    });

  }
  Future<String> login({required context})
  async {
     String massege =loginValidation();
     if(massege!='true') return massege;
    emit(LoginLoadingState());
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: loginEmail.text,
      password: loginPassword.text,
    ).then((value)
    {
      clearControllers();
      emit(LoginSucssedState());
    }).catchError((error)
    {
      clearControllers();
      emit(LoginErrorState());
      print(error);
    });

     return state is LoginSucssedState ? 'true' : 'wrong email or password';
  }

 Future<String> logout({required context})
  async {
    emit(LogoutLoadingState());
    await FirebaseAuth.instance.signOut().
    then((value) {
      emit(LogoutErrorState());
      ProfileCubit.get(context).userDataModel=null;
      emit(LogoutSucssedState());
    }).catchError((error){
      clearControllers();
      print(error);
      emit(LogoutErrorState());
    });

    return state is LogoutSucssedState?'true':'log out failed';
  }

  Future<String> forgetPassword(String email)
  async {
     emit(ForgetPasswordLoadingState());
    await FirebaseAuth.instance.sendPasswordResetEmail(email:email)
        .then((value) {
          emit(ForgetPasswordSucssedState());
    })
        .catchError((error){
          emit(ForgetPasswordErrorState());
          print(error);

    });
     clearControllers();
    return state is ForgetPasswordSucssedState?'true':'reset password failed';
  }

  getRegistrationCode()
  async {
     emit(GetRegistrationCodesLoadingState());
    await FirebaseFirestore.instance.collection(Constants.kRegistrationCodeCollectionId).doc('vDUPuKtnUpXzN297yJk1')
        .get()
        .then((value) {
          couchRegistrationCodeController.text=value.data()!['couch code'];
          ownerRegistrationCodeController.text=value.data()!['owner code'];
          emit(GetRegistrationCodesSucssedState());
    })
        .catchError((error){
          print(error);
          emit(GetRegistrationCodesErrorState());
    });

  }
  updateRegistrationCode({required context})
  async {
     emit(UpdateRegistrationCodesLoadingState());
    await FirebaseFirestore.instance.collection(Constants.kRegistrationCodeCollectionId).doc('vDUPuKtnUpXzN297yJk1').update(
      {
            'couch code':couchRegistrationCodeController.text,
            'owner code':ownerRegistrationCodeController.text
      }
    ).then((value) {
      emit(UpdateRegistrationCodesSucssedState());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Update Code Success')));
    })
        .catchError((error){
      print(error);
      emit(UpdateRegistrationCodesErrorState());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(error.toString())));

    });

  }



}
