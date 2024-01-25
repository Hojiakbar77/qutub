part of 'location_bloc.dart';

@immutable
abstract class LocationState {}

class LocationInitial extends LocationState {}
class CheckUserResult extends LocationState{
  final dynamic response;
  final dynamic statusCode;

  CheckUserResult({required this.response,required this.statusCode});
}
class CheckDataFailure extends LocationState {
  final dynamic message;
  CheckDataFailure({required this.message});
}
class CheckDataSuccess extends LocationState {
  final dynamic message;
  CheckDataSuccess({required this.message});
}