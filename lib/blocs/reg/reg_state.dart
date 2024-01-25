part of 'reg_bloc.dart';


abstract class LoginState {}

class LoginInitial extends LoginState {}

class CheckUserResult extends LoginState{
  final dynamic response;
  final dynamic statusCode;

  CheckUserResult({required this.response,required this.statusCode});
}
class CheckUserSuccess extends LoginState {
  final String token;
  CheckUserSuccess({required this.token});
}

class CheckUserFailure extends LoginState {
  final dynamic message;
  CheckUserFailure({required this.message});
}
