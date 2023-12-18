import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/core/constants/constants.dart';
import 'package:gym/core/models/api_models/excercies_model.dart';
import 'package:gym/core/services/excercies_services.dart';
import 'package:meta/meta.dart';

part 'excercies_state.dart';

class ExcerciesCubit extends Cubit<ExcerciesState> {
  ExcerciesCubit() : super(ExcerciesInitial());
  static ExcerciesCubit get(context)=>BlocProvider.of(context);
  TextEditingController searchController=TextEditingController();
    ExcerciesModel? excerciesModel,bodyPartModel;
    List<String> bodyParts=[
      "back",
      "cardio",
      "chest",
      "lower arms",
      "lower legs",
      "neck",
      "shoulders",
      "upper arms",
      "upper legs",
      "waist"
    ];
    List<String> bodyPartsImages=[
      Constants.kBack,
      Constants.kCardio,
      Constants.kChest,
      Constants.kArm,
      Constants.kLeg,
      Constants.kNeck,
      Constants.kShoulders,
      Constants.kArm,
      Constants.kLeg,
      Constants.kWaist,
    ];
    getAllExcercies()
    async {
      emit(GetAllExcerciesLoadingState());
    await   DioHelper.getData(
          url: 'exercises',
        query: {
            'limit':1500
        }
      )
          .then((value) async {
            excerciesModel=await ExcerciesModel.fromJson({'excercies':value.data});
            emit(GetAllExcerciesSuccessState());
      })
          .catchError((error){
            print(error);
            emit(GetAllExcerciesErrorState());
      });
    }
    searchGeneralExcercies()
    async {
      if(searchController.text.isEmpty) return;
      emit(SearchGeneralyExcerciesLoadingState());
      await   DioHelper.getData(
          url: 'exercises/name/${searchController.text}',
        query: {
            'limit':1500
        }
      )
          .then((value) async {
        excerciesModel=await ExcerciesModel.fromJson({'excercies':value.data});
        emit(SearchGeneralyExcerciesSuccessState());
      })
          .catchError((error){
        print(error);
        emit(SearchGeneralyExcerciesErrorState());
      });
    }
  getBodyPartExcercies({required String bodyPartName})
  async {
    emit(GetBodyPartExcerciesLoadingState());
    await   DioHelper.getData(
      url: 'exercises/bodyPart/${bodyPartName}',
      query: {
        'limit':1500
      }
    )
        .then((value) async {
      bodyPartModel=await ExcerciesModel.fromJson({'excercies':value.data});
      emit(GetBodyPartExcerciesSuccessState());
    })
        .catchError((error){
      print(error);
      emit(GetBodyPartExcerciesErrorState());
    });
  }

}
