part of 'booking_cubit.dart';

@immutable
abstract class BookingState {}

class BookingInitial extends BookingState {}
class ChangeSelectedDayState extends BookingState {}
class ChangeSelectedClassStartTimeState extends BookingState {}

class AddClassGymLoadingState extends BookingState {}
class AddClassGymSuccessState extends BookingState {}
class AddClassGymErrorState extends BookingState {}

class GetAllAvailableClassLoadingState extends BookingState {}
class GetAllAvailableClassSuccessState extends BookingState {}
class GetAllAvailableClassErrorState extends BookingState {}

class DeleteGymClassLoadingState extends BookingState {}
class DeleteGymClassSuccessState extends BookingState {}
class DeleteGymClassErrorState extends BookingState {}

class AddGymClassToHistoryLoadingState extends BookingState {}
class AddGymClassToHistorySuccessState extends BookingState {}
class AddGymClassToHistoryErrorState extends BookingState {}

class CancelGymClassFromHistoryLoadingState extends BookingState {}
class CancelGymClassFromHistorySuccessState extends BookingState {}
class CancelGymClassFromHistoryErrorState extends   BookingState {}

class GetHistoryClassesHistoryLoadingState extends BookingState {}
class GetHistoryClassesHistorySuccessState extends BookingState {}
class GetHistoryClassesHistoryErrorState extends   BookingState {}

class BookClassLoadingState extends BookingState {}
class BookClassSuccessState extends BookingState {}
class BookClassErrorState extends BookingState {}

class CancelBookedClassLoadingState extends BookingState {}
class CancelBookedClassSuccessState extends BookingState {}
class CancelBookedClassErrorState extends BookingState {}

class IncrementCustomerNumberLoadingState extends BookingState {}
class IncrementCustomerNumberSuccessState extends BookingState {}
class IncrementCustomerNumberErrorState extends BookingState {}

class DecrementCustomerNumberLoadingState extends BookingState {}
class DecrementCustomerNumberSuccessState extends BookingState {}
class DecrementCustomerNumberErrorState extends BookingState {}

class ReturnAllCreditsLoadingState extends BookingState {}
class ReturnAllCreditsSuccessState extends BookingState {}
class ReturnAllCreditsErrorState extends BookingState {}

class GetRecentBookedClassesLoadingState extends BookingState {}
class GetRecentBookedClassesSuccessState extends BookingState {}
class GetRecentBookedClassesErrorState extends BookingState {}