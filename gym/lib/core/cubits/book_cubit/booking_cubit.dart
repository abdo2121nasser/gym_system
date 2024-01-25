import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/blocks/alert_dialog_box_block.dart';
import 'package:gym/core/cubits/authentication_cubit/authentication_cubit.dart';
import 'package:gym/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:gym/core/models/firebase_models/booking_data_data_model.dart';
import 'package:gym/core/models/firebase_models/class_customer_model.dart';
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
  List<BookingClassesModel> myDailySchedulModel=[];
    List<BookingHistory> historyClasses=[];
    List<BookingHistory> recentClasses=[];
  List<ClassCustomerModel> customerAttendList=[];
  List<ClassCustomerModel> customerAbsentList=[];
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
      'max customer number': classMaxCustomer.text==''? int.parse(classMaxCustomer.text):30,
      'start date':Timestamp.fromDate(DateTime(selectedDay.year,selectedDay.month,selectedDay.day)),
      'start time hour':classStartTime!.hour,
      'start time minute':classStartTime!.minute,
      'customer number':0
    })
        .then((value) {
          className.clear();
          classCouchName.clear();
          classStartTime=TimeOfDay.now();
          classMaxCustomer.text='30';
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
     if(availableClassesModel.isEmpty)
       {
         await FirebaseFirestore.instance
             .collection(Constants.kGymClassesCollectionId)
             .where('start date',isEqualTo: Timestamp.fromDate(DateTime(selectedDay.year,selectedDay.month,selectedDay.day)))
             .orderBy('start time hour').get()
             .then((value) async {
               availableClassesModel.clear();
               value.docs.forEach((element) {
                 availableClassesModel.add(BookingClassesModel.fromJson(snapshot: element.data(),documentId:element.id ));

               });
           emit(GetAllAvailableClassSuccessState());
         })
             .catchError((error){
           emit(GetAllAvailableClassErrorState());
           print('${error}');
         });
       }
    }

    deleteGymClass({required String docId,required context})
    async {
      emit(DeleteGymClassLoadingState());
   await returnAllCredits(classDocIc: docId,context: context);
   await  FirebaseFirestore.instance
          .collection(Constants.kGymClassesCollectionId)
          .doc(docId).delete()
          .then((value) async {
        emit(DeleteGymClassSuccessState());
       await getAllAvailableClass();
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('success delete class')));
      }).catchError((error){
        emit(DeleteGymClassErrorState());
        print(error);
      });
    }
    returnAllCredits({required String classDocIc,required context})
    async {
       emit(ReturnAllCreditsLoadingState());
        await FirebaseFirestore.instance.collection(Constants.kGymClassesCollectionId).doc(classDocIc).collection(Constants.kGymClassCustomerCollectionId)
            .get()
            .then((value) {
              value.docs.forEach((element) async {
               await FirebaseFirestore.instance.collection(Constants.kUsersCollectionId).where('email',isEqualTo: element.data()['email']).get()
                    .then((value) async {
                      if(await FirebaseFirestore.instance.collection(Constants.kUsersCollectionId).doc(value.docs[0].id)
                          .collection(Constants.kGymClassesHistoryBookingCollectionId).get().then((value)
                      {return value.docs.isNotEmpty;}
                      )
                      )
               {
                await  ProfileCubit.get(context).incrementCredit(currentCredit1: value.docs[0].data()['current credit']+1,docId:  value.docs[0].id);
                await cancelClassGymFromHistory(mainDocId: value.docs[0].id,
                    subDocId:  await FirebaseFirestore.instance.collection(Constants.kUsersCollectionId).doc(value.docs[0].id).collection(Constants.kGymClassesHistoryBookingCollectionId).where('document id',isEqualTo: classDocIc).get().then((value) {return value.docs[0].id;}).catchError((error){print(error);}),
                    context: context);
                getHistroyGymClasses(context: context);
              }

                })
                    .catchError((error){
                      print(error);
                });
              });
              emit(ReturnAllCreditsSuccessState());
        })
            .catchError((error){
          emit(ReturnAllCreditsErrorState());
              print(error);
        });




    }




    getHistroyGymClasses({required context})
    async {
      emit(GetHistoryClassesHistoryLoadingState());
      if(ProfileCubit.get(context).userDataModel==null) {
        await  ProfileCubit.get(context).reciveAllUserData();
      }

      await FirebaseFirestore.instance.collection(Constants.kUsersCollectionId)
          .doc(await ProfileCubit.get(context).userDataModel!.docId).collection(Constants.kGymClassesHistoryBookingCollectionId)
          .get()
          .then((value) {
        historyClasses.clear();
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
        'attended':true
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

   decrementCustomerNumber({required String docId,required int customerNumber})
   async {
    emit(DecrementCustomerNumberLoadingState());
    await FirebaseFirestore.instance.collection(Constants.kGymClassesCollectionId).doc(docId)
        .update({
      'customer number':customerNumber-1
    })
        .then((value) {
          emit(DecrementCustomerNumberSuccessState());
    })
        .catchError((error){
          emit(DecrementCustomerNumberErrorState());
           print(error);
    });
   }
  incrementCustomerNumber({required String docId,required int customerNumber})
  async {
    emit(IncrementCustomerNumberLoadingState());
    await FirebaseFirestore.instance.collection(Constants.kGymClassesCollectionId).doc(docId)
        .update({
      'customer number':customerNumber+1
    })
        .then((value) {
          emit(IncrementCustomerNumberSuccessState());

    })
        .catchError((error){
          emit(IncrementCustomerNumberErrorState());
      print(error);
    });
  }

  bookClass({required String classDocId,required UserDataModel object,required context,required String historyDocId,required BookingClassesModel historyObject})
  async {
   await ProfileCubit.get(context).reciveAllUserData();
    emit(BookClassLoadingState());
    CollectionReference data = FirebaseFirestore.instance.collection(Constants.kGymClassesCollectionId);
  await data.doc(classDocId).collection(Constants.kGymClassCustomerCollectionId)
        .add({
      'email':object.email,
      'user name':object.name,
      'phone':object.phone,
      'user priority':object.priority,
      'attended':true,
    'image url': ProfileCubit.get(context).userDataModel!.imageUrl,
     'customer doc id':object.docId,
    })
        .then((value) async {
      await addGymClassToHistory(userDocId:historyDocId , object:historyObject,context: context);
      await ProfileCubit.get(context).decrementCredit();
      await incrementCustomerNumber(docId: classDocId, customerNumber: historyObject.customerNumber!);
      await  getAllAvailableClass();
      print(availableClassesModel.length);
      emit(BookClassSuccessState());
     await ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booked'),duration: Duration(seconds: 1),));
    })
        .catchError((error){
      emit(BookClassErrorState());
      print(error);
    });

  }

  cancelBookedClass({required String mainDocId, required String email,required context
    ,required String historyMainDocId,required String historySubDocId
    ,required int customerNumber,bool isIncrement=true})
  async {
    emit(CancelBookedClassLoadingState());
    await FirebaseFirestore.instance
        .collection(Constants.kGymClassesCollectionId).doc(mainDocId).collection(Constants.kGymClassCustomerCollectionId)
        .doc(
       await FirebaseFirestore.instance.collection(Constants.kGymClassesCollectionId).doc(mainDocId).collection(Constants.kGymClassCustomerCollectionId).where('email',isEqualTo:email ).get().then((value) {
         return value.docs[0].id;}).catchError((error){print(error);})
    )
        .delete()
        .then((value) async {
         await cancelClassGymFromHistory(mainDocId: historyMainDocId, subDocId: historySubDocId, context: context);
       if(isIncrement) {
        await ProfileCubit.get(context).reciveAllUserData();
         await ProfileCubit.get(context).incrementCredit(currentCredit1: ProfileCubit.get(context).userDataModel!.currentCredit!+1,docId: ProfileCubit.get(context).userDataModel!.docId!);
       }
       await decrementCustomerNumber(docId: mainDocId, customerNumber: customerNumber);
      //await  getAllAvailableClass();
      await getHistroyGymClasses(context: context);
      emit(CancelBookedClassSuccessState());
        await ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('canceled')));
    }).catchError((error){
      emit(CancelBookedClassErrorState());
      print(error);
    });
  }

  getRecentBookedClasses({required context})
  async {
    emit(GetRecentBookedClassesLoadingState());
   try
   {
    await getHistroyGymClasses(context: context);
    recentClasses.clear();
     historyClasses.forEach((element) {
       if(
            element.startDate.toDate().year.toInt()>= DateTime.now().year.toInt()
           &&  element.startDate.toDate().month.toInt()>= DateTime.now().month.toInt()
           &&  element.startDate.toDate().day.toInt()>= DateTime.now().day.toInt())
       {
         if (element.startDate.toDate().day.toInt() == DateTime.now().day.toInt()
             && element.startTimeHour.toInt() > DateTime.now().hour.toInt())
         {
           recentClasses.add(element);
         }
         else if(element.startDate.toDate().day.toInt() > DateTime.now().day.toInt())
           {
             recentClasses.add(element);
           }
       }

     });
    recentClasses.sort((a, b) {
      if (a.startDate.toDate().year != b.startDate.toDate().year) {
        return a.startDate.toDate().year.compareTo(b.startDate.toDate().year);
      }
      if (a.startDate.toDate().month != b.startDate.toDate().month) {
        return a.startDate.toDate().month.compareTo(b.startDate.toDate().month);
      }
      if (a.startDate.toDate().day != b.startDate.toDate().day) {
        return a.startDate.toDate().day.compareTo(b.startDate.toDate().day);
      }
      return a.startTimeHour.compareTo(b.startTimeHour);
    });
     emit(GetRecentBookedClassesSuccessState());
   }catch(error)
    {
      emit(GetRecentBookedClassesErrorState());
      print(error);
    }
  }

     getMyDailySchedule({required String couchName})
     async {
    myDailySchedulModel.clear();
       emit(GetMyDailyScheduleLoadingState());
       await FirebaseFirestore.instance.collection(Constants.kGymClassesCollectionId)
           .where('couch name',isEqualTo: couchName,)
           .where('start date',isEqualTo:Timestamp.fromDate(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)))
           .get()
           .then((value) {
             value.docs.forEach((element) {
                  myDailySchedulModel.add(BookingClassesModel.fromJson(snapshot: element.data(), documentId: element.id));
             });
         emit(GetMyDailyScheduleSuccessState());
       })
           .catchError((error){
         emit(GetMyDailyScheduleErrorState());
         print(error);
       });
     }

     getClassCustomerList({required String mainDocId})
     async {
  emit(GetCustomerAttendListLoadingState());
  await FirebaseFirestore.instance.collection(Constants.kGymClassesCollectionId).doc(mainDocId)
      .collection(Constants.kGymClassCustomerCollectionId).get()
      .then((value) {
        customerAttendList.clear();
        customerAbsentList.clear();
    value.docs.forEach((element) {
        if(element.data()['attended']==true) {
          customerAttendList.add(ClassCustomerModel.fromJson(
              json: element.data(), docId: element.id));
        }
        else
          {
            customerAbsentList.add(ClassCustomerModel.fromJson(json: element.data(),docId: element.id));
          }
    });

        emit(GetCustomerAttendListSucssedState());
  })
      .catchError((error){
        emit(GetCustomerAttendListErrorState());
        print(error);
  });
     }

     setCustomerAbsent({required String mainDocId,required String subDocId,required context,required String customerDocId})
     async {
       emit(SetCustomerAbsentLoadingState());
       await FirebaseFirestore.instance.collection(Constants.kGymClassesCollectionId).doc(mainDocId).collection(Constants.kGymClassCustomerCollectionId).doc(subDocId)
           .update({
         'attended':false
       })
           .then((value) async {
         setCustomerAbsentInHistory(context: context,subDocId: subDocId,mainDocId: mainDocId,customerDocId: customerDocId);
            await getClassCustomerList(mainDocId: mainDocId);
         emit(SetCustomerAbsentSucssedState());
       })
           .catchError((error){
             emit(SetCustomerAbsentErrorState());
             print(error);
       });

     }
  setCustomerAbsentInHistory({required String subDocId,required context,required String mainDocId,required String customerDocId})
  async {
    emit(SetCustomerAbsentInHistoryLoadingState());
    String historySubDocId=await FirebaseFirestore.instance
        .collection(Constants.kUsersCollectionId).doc(customerDocId)
        .collection(Constants.kGymClassesHistoryBookingCollectionId)
        .where('document id',isEqualTo: mainDocId).get().then((value){
          return value.docs[0].id;
    });
    await FirebaseFirestore.instance.collection(Constants.kUsersCollectionId).doc(customerDocId)
        .collection(Constants.kGymClassesHistoryBookingCollectionId).doc(historySubDocId)
        .update({
      'attended':false
    })
        .then((value) async {
      emit(SetCustomerAbsentInHistorySucssedState());
    })
        .catchError((error){
      emit(SetCustomerAbsentInHistoryErrorState());
      print(error);
    });

  }
  setCustomerAttendedInHistory({required String subDocId,required context,required String mainDocId,required String customerDocId})
  async {

    emit(SetCustomerAttendedInHistoryLoadingState());
    String historySubDocId=await FirebaseFirestore.instance.collection(Constants.kUsersCollectionId).doc(customerDocId)
        .collection(Constants.kGymClassesHistoryBookingCollectionId)
        .where('document id',isEqualTo: mainDocId).get().then((value){
      return value.docs[0].id;
    });
    await FirebaseFirestore.instance.collection(Constants.kUsersCollectionId).doc(customerDocId)
        .collection(Constants.kGymClassesHistoryBookingCollectionId).doc(historySubDocId)
        .update({
      'attended':true
    })
        .then((value) async {
      emit(SetCustomerAttendedInHistorySucssedState());
    })
        .catchError((error){
      emit(SetCustomerAttendedInHistoryErrorState());
      print(error);
    });

  }

  setCustomerAttended({required String mainDocId,required String subDocId,required context,required String customerDocId})
  async {
    emit(SetCustomerAttendedLoadingState());
    await FirebaseFirestore.instance.collection(Constants.kGymClassesCollectionId).doc(mainDocId).collection(Constants.kGymClassCustomerCollectionId).doc(subDocId)
        .update({
      'attended':true
    })
        .then((value) async {
      setCustomerAttendedInHistory(context: context,subDocId: subDocId,mainDocId: mainDocId,customerDocId: customerDocId );
      await getClassCustomerList(mainDocId: mainDocId);
      emit(SetCustomerAttendedSucssedState());
    })
        .catchError((error){
      emit(SetCustomerAttendedErrorState());
      print(error);
    });

  }





}







