import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart 'as http;

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<LocationEvent>((event, emit) async {
      if (event is CheckUserEvent) {
        try {
          String myUrl = "https://qutb.uz/api/ads";
          final Map<String, String> headers = {
            'Content-Type': 'application/json',
          };
          final Map<String, String> body = {
            "title": event.title,
            "description": event.description,
            "lot": event.lot.toString(),
            "lang": event.lang.toString(),

          };

          final response = await http.post(
            Uri.parse(myUrl),
            headers: headers,
            body: jsonEncode(body),
          );

          if (response.statusCode == 201){
            final decode = jsonDecode(response.body);
            print(response.statusCode);
            emit(CheckDataSuccess(message: "Success"));
          } else if (response.statusCode == 501) {
            emit(CheckDataFailure(message: "Iltimos qaytadan urinib ko'ring"));
            print("Status code  ${response.statusCode}");
          } else {
            print("Status code ${response.statusCode}");
            print("Status code ${response.body}");

            emit(CheckDataFailure(message: " Iltimos qaytadan urinib ko'ring")) ;
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
