import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/blocks/alert_dialog_box_block.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/core/models/firebase_models/booking_data_data_model.dart';
import 'package:meta/meta.dart';

import '../../constants/constants.dart';
import '../../models/firebase_models/user_data_model.dart';
part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());
  static BookingCubit get(context)=>BlocProvider.of(context);
  DateTime selectedDay=DateTime.now();
  TextEditingController className=TextEditingController();
     TimeOfDay? classStartTime=TimeOfDay.now();
  TextEditingController classCouchName=TextEditingController();
  TextEditingController classMaxCustomer=TextEditingController(text: '30');
    List<BookingClassesModel> availableClassesModel=[];
    List<BookingHistory> historyClasses=[];
  changeSelectedDay(DateTime day)
  {
     selectedDay=day;
     emit(ChangeSelectedDayState());
     getAllAvailableClass();
  }
   showDialogBox({required context})
   {
    return showDialog(context: context,
      builder: (context) {
      return AlertDialogBoxBlock(
        addFunction: (){
          addGymClasses(context: context);
          Navigator.of(context).pop();
          classStartTime=TimeOfDay.now();
          className.clear();
          classMaxCustomer.text='30';
          classCouchName.clear();
        },
        cancelFunction: (){
          Navigator.of(context).pop();
          classStartTime=TimeOfDay.now();
          className.clear();
          classMaxCustomer.text='30';
          classCouchName.clear();
        },
        updatetime: () {
       updateClassStartTime(context: context);
      },
        classMaxCustomerNumber: classMaxCustomer,
        className: className,
        classCouchName: classCouchName,
        classStartTime: classStartTime,);
    },);
   }
   updateClassStartTime({required context})
   async {
      await showTimePicker(
       context: context,
       initialTime: TimeOfDay.now(),
     ).then((value) async {
       classStartTime=await value;
       emit(ChangeSelectedClassStartTimeState());
      });

   }




  addGymClasses({required context})
  async {
    emit(AddClassGymLoadingState());
    CollectionReference data = FirebaseFirestore.instance.collection(Constants.kGymClassesCollectionId);
    await  data.add({
      'class name':className.text,
      'couch name':classCouchName.text,
      'max customer number':  int.parse(classMaxCustomer.text),
      'start date':Timestamp.fromDate(DateTime(selectedDay.year,selectedDay.month,selectedDay.day)),
      'start time hour':classStartTime!.hour,
      'start time minute':classStartTime!.minute,
      'customer number':0
    })
        .then((value) {
          className.clear();
          classCouchName.clear();
          classMaxCustomer.clear();
          emit(AddClassGymSuccessState());
          getAllAvailableClass();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('success add Class')));

    })
        .catchError((error){
          print(error);
          emit(AddClassGymErrorState());
    });
  }

    getAllAvailableClass()
    async {
      emit(GetAllAvailableClassLoadingState());
      availableClassesModel.clear();
      await FirebaseFirestore.instance
          .collection(Constants.kGymClassesCollectionId)
      .where('start date',isEqualTo: Timestamp.fromDate(DateTime(selectedDay.year,selectedDay.month,selectedDay.day)))
          .orderBy('start time hour').get()
          .then((value) async {
            for(int i=0;i<value.docs.length;i++)
              {
                availableClassesModel!.add(await BookingClassesModel.fromJson(snapshot: await value.docs[i].data(),documentId:value.docs[i].id ));

              }
            emit(GetAllAvailableClassSuccessState());

      })
          .catchError((error){
            emit(GetAllAvailableClassErrorState());
            print('${error}  -----------------------------------------------');
      });
    }

    deleteGymClass({required String docId})
    async {
      emit(DeleteGymClassLoadingState());

    await  FirebaseFirestore.instance
          .collection(Constants.kGymClassesCollectionId)
          .doc(docId)
          .delete()
          .then((value) {
        emit(DeleteGymClassSuccessState());
      }).catchError((error){
        emit(DeleteGymClassErrorState());
        print(error);
      });
    }
    getHistroyGymClasses({required context})
    async {
      emit(GetHistoryClassesHistoryLoadingState());
      historyClasses.clear();
      await FirebaseFirestore.instance.collection(Constants.kUsersCollectionId)
          .doc(ProfileCubit.get(context).userDataModel!.docId).collection(Constants.kGymClassesHistoryBookingCollectionId)
          .get()
          .then((value) {

            value.docs.forEach((element) {
              historyClasses.add(BookingHistory.fromJson(snapshot: element.data(), cSubDocId: element.id));
            });

            emit(GetHistoryClassesHistorySuccessState());
      })
          .catchError((error){
            emit(GetHistoryClassesHistoryErrorState());
            print(error);
      });
    }



    addGymClassToHistory({required String userDocId,required BookingClassesModel object,context})
    {
      emit(AddGymClassToHistoryLoadingState());
      CollectionReference data = FirebaseFirestore.instance.collection(Constants.kUsersCollectionId);
      data.doc(userDocId).collection(Constants.kGymClassesHistoryBookingCollectionId)
          .add({
        'class name':object.className,
        'couch name':object.couchName,
        'max customer number':  object.maxCustomerNumber,
        'start date':object.startDate,
        'start time hour':object.startTimeHour,
        'start time minute':object.startTimeMinute,
        'document id':object.docId,
      })
          .then((value) {
            emit(AddGymClassToHistorySuccessState());
            ProfileCubit.get(context).reciveAllUserData();
            getHistroyGymClasses(context: context);
      })
          .catchError((error){
              emit(AddGymClassToHistoryErrorState());
              print(error);
      });

    }

    cancelClassGymFromHistory({required String mainDocId, required String subDocId,required context,})
  async {
    emit(CancelGymClassFromHistoryLoadingState());
   await FirebaseFirestore.instance
        .collection(Constants.kUsersCollectionId).doc(mainDocId).collection(Constants.kGymClassesHistoryBookingCollectionId).doc(subDocId)
        .delete()
        .then((value) async {
     await ProfileCubit.get(context).reciveAllUserData();
     getHistroyGymClasses(context: context);
     emit(CancelGymClassFromHistorySuccessState());
    }).catchError((error){
      emit(CancelGymClassFromHistoryErrorState());
      print(error);
    });


  }


  String getClassDocIdValue({required String searchValue,required context}) {
    var resultObject = BookingCubit.get(context).historyClasses.firstWhere((obj) => obj.subDocId == searchValue,);
    return resultObject.currentSubDocId;
  }


  bookClass({required String classDocId,required UserDataModel object,required context,required String historyDocId,required BookingClassesModel historyObject})
  {
    emit(BookClassLoadingState());
    CollectionReference data = FirebaseFirestore.instance.collection(Constants.kGymClassesCollectionId);
    data.doc(classDocId).collection(Constants.kGymClassCustomerCollectionId)
        .add({
      'email':object.email,
      'user name':object.name,
      'phone':object.phone,
      'user priority':object.priority

    })
        .then((value) {
        addGymClassToHistory(userDocId:historyDocId , object:historyObject,context: context);
      emit(BookClassSuccessState());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booked')));
    })
        .catchError((error){
      emit(BookClassErrorState());
      print(error);
    });

  }

  cancelBookedClass({required String mainDocId, required String email,required context,required String historyMainDocId,required String historySubDocId,})
  async {
    emit(CancelBookedClassLoadingState());
    await FirebaseFirestore.instance
        .collection(Constants.kGymClassesCollectionId).doc(mainDocId).collection(Constants.kGymClassCustomerCollectionId)
        .doc(
       await FirebaseFirestore.instance.collection(Constants.kGymClassesCollectionId).doc(mainDocId).collection(Constants.kGymClassCustomerCollectionId).where('email',isEqualTo:email ).get().then((value) {
         return value.docs[0].id;})
    )
        .delete()
        .then((value) async {
         await cancelClassGymFromHistory(mainDocId: historyMainDocId, subDocId: historySubDocId, context: context);
          //todo update class pacage
      await  getAllAvailableClass();
     await getHistroyGymClasses(context: context);
      emit(CancelBookedClassSuccessState());
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('canceled')));
    }).catchError((error){
      emit(CancelBookedClassErrorState());
      print(error);
    });


  }



}
