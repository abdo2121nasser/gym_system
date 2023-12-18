part of 'excercies_cubit.dart';

@immutable
abstract class ExcerciesState {}

class ExcerciesInitial extends ExcerciesState {}
class GetAllExcerciesLoadingState extends ExcerciesState {}
class GetAllExcerciesSuccessState extends ExcerciesState {}
class GetAllExcerciesErrorState extends ExcerciesState {}

class SearchGeneralyExcerciesLoadingState extends ExcerciesState {}
class SearchGeneralyExcerciesSuccessState extends ExcerciesState {}
class SearchGeneralyExcerciesErrorState extends ExcerciesState {}

class GetBodyPartExcerciesLoadingState extends ExcerciesState {}
class GetBodyPartExcerciesSuccessState extends ExcerciesState {}
class GetBodyPartExcerciesErrorState extends ExcerciesState {}

class GetTargetExcerciesLoadingState extends ExcerciesState {}
class GetTargetExcerciesSuccessState extends ExcerciesState {}
class GetTargetExcerciesErrorState extends ExcerciesState {}