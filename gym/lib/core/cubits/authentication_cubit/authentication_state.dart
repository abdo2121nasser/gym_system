part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class ClearControllersState extends AuthenticationState {}

class ChangeToLogInScreenState extends AuthenticationState {}
class ChangeToSignUpScreenState extends AuthenticationState {}

class RegisterLoadingState extends AuthenticationState {}
class RegisterSucssedState extends AuthenticationState {}
class RegisterErrorState extends AuthenticationState {}

class LoginLoadingState extends AuthenticationState {}
class LoginSucssedState extends AuthenticationState {}
class LoginErrorState extends AuthenticationState {}

class LogoutLoadingState extends AuthenticationState {}
class LogoutSucssedState extends AuthenticationState {}
class LogoutErrorState extends AuthenticationState {}

class ForgetPasswordLoadingState extends AuthenticationState {}
class ForgetPasswordSucssedState extends AuthenticationState {}
class ForgetPasswordErrorState extends AuthenticationState {}

class SendVerifyEmailLoadingState extends AuthenticationState {}
class SendVerifyEmailSucssedState extends AuthenticationState {}
class SendVerifyEmailErrorState extends AuthenticationState {}

class CheckVerifyEmailLoadingState extends AuthenticationState {}
class CheckVerifyEmailSucssedState extends AuthenticationState {}

class RegistrationSaveDataLoadingState extends AuthenticationState {}
class RegistrationSaveDataSucssedState extends AuthenticationState {}
class RegistrationSaveDataErrorState extends AuthenticationState {}

class ChangeCheckBoxValueState extends AuthenticationState {}

class GetRegistrationCodesLoadingState extends AuthenticationState {}
class GetRegistrationCodesSucssedState extends AuthenticationState {}
class GetRegistrationCodesErrorState extends AuthenticationState {}

class UpdateRegistrationCodesLoadingState extends AuthenticationState {}
class UpdateRegistrationCodesSucssedState extends AuthenticationState {}
class UpdateRegistrationCodesErrorState extends AuthenticationState {}
