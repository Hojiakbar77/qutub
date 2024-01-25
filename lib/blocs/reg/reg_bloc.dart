import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart 'as http;



part 'reg_event.dart';

part 'reg_state.dart';

class RegBloc extends Bloc<LoginEvent, LoginState> {
  final box = GetStorage();
  RegBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is CheckUserEvent) {
        try {
          String myUrl = "https://qutb.uz/api/auth/register";
          final Map<String, String> headers = {
            'Content-Type': 'application/json',
          };
          final Map<String, String> body = {
            "firstname": event.firstname,
            "lastname": event.lastname,
            "phone": event.phone,
            "password": event.password,

          };

          final response = await http.post(
            Uri.parse(myUrl),
            headers: headers,
            body: jsonEncode(body),
          );

          if (response.statusCode == 201) {
            // Registration successful, save token to storage and return the response body

            final decode = jsonDecode(response.body);
            await box.remove("accessToken").then((value) => box.write('accessToken',decode["accessToken"]));
            print(response.statusCode);

            emit(CheckUserSuccess(token: decode["accessToken"]));



          } else if (response.statusCode == 401) {
            print("Status codeeeeeeeeeee  ${response.statusCode}");
            // Registration failed with a specific error message, return the error message
            emit(CheckUserFailure(message: "Registratsiya muvaffiqiyatsiz. Iltimos qaytadan urinib ko'ring"));
          } else {
            print("Status codeeeeeeeeeee ${response.statusCode}");
            print("Status codeeeeeeeeeee ${response.body}");
            // Registration failed with a generic error message, return a default error message
            emit(CheckUserFailure(message: "Registratsiya muvaffiqiyatsiz. Iltimos qaytadan urinib ko'ring")) ;
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
