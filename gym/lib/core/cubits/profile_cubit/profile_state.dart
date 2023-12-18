part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}
class ProfileInitial extends ProfileState {}
class SetControllersState extends ProfileState {}

class PickImageLoadingState extends ProfileState {}
class PickImageSuccessState extends ProfileState {}
class PickImageErrorState extends ProfileState {}

class UploadImageLoadingState extends ProfileState {}
class UploadImageSuccessState extends ProfileState {}
class UploadImageErrorState extends ProfileState {}

class GetImageUrlLoadingState extends ProfileState {}
class GetImageUrlSuccessState extends ProfileState {}
class GetImageUrlErrorState extends ProfileState {}

class ReciveAllUserDataLoadingState extends ProfileState {}
class ReciveAllUserDataSuccessState extends ProfileState {}
class ReciveAllUserDataErrorState extends ProfileState {}

class UpdateProfileLoadingState extends ProfileState {}
class UpdateProfileSuccessState extends ProfileState {}
class UpdateProfileErrorState extends ProfileState {}

class UpdateEmailLoadingState extends ProfileState {}
class UpdateEmailSuccessState extends ProfileState {}
class UpdateEmailErrorState extends ProfileState {}

