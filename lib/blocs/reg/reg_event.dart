part of 'reg_bloc.dart';


abstract class LoginEvent {}

class InitialLoginBloc extends LoginEvent{}

class CheckUserEvent extends LoginEvent{
  final String firstname;
  final String lastname;
  final String phone;
  final String password;

  CheckUserEvent({required this.firstname,required this.lastname,required this.phone,required this.password});
}
