part of 'navigation_cubit.dart';

@immutable
abstract class NavigationState {}

class NavigationInitial extends NavigationState {}
class ChangeScreenIndexState extends NavigationState {}
class ChangeTabViewScreenIndexState extends NavigationState {}
