part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}
class ProfileInitial extends ProfileState {}
class SetControllersState extends ProfileState {}
class CreditDateValidationState extends ProfileState {}

class SetStartCreditState extends ProfileState {}
class SetEndCreditState extends ProfileState {}

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

class GetCreditUserDataLoadingState extends ProfileState {}
class GetCreditUserDataSuccessState extends ProfileState {}
class GetCreditUserDataErrorState extends ProfileState {}

class UpdateCreditLoadingState extends ProfileState {}
class UpdateCreditSuccessState extends ProfileState {}
class UpdateCreditErrorState extends ProfileState {}

class IncrementCreditLoadingState extends ProfileState {}
class IncrementCreditSuccessState extends ProfileState {}
class IncrementCreditErrorState extends ProfileState {}

class DecrementCreditLoadingState extends ProfileState {}
class DecrementCreditSuccessState extends ProfileState {}
class DecrementCreditErrorState extends ProfileState {}