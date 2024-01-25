part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {}
class CheckUserEvent extends LocationEvent{
  final String title;
  final String description;
  final dynamic lot;
  final dynamic lang;

  CheckUserEvent({required this.title,required this.description,required this.lot,required this.lang});
}
