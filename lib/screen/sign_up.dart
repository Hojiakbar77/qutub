import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get_storage/get_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../blocs/reg/reg_bloc.dart';
import '../utils/colors.dart';
import 'map.dart';


class SignUPPage extends StatefulWidget {
  const SignUPPage({Key? key}) : super(key: key);

  @override
  State<SignUPPage> createState() => _SignUPPageState();
}

class _SignUPPageState extends State<SignUPPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController number = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirm = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '+### (##) ###-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  String removeNonNumeric(String input) {
    return input.replaceAll(RegExp(r'[^\d]'), '');
  }

  bool _obscurePassword = true;
  bool _obscurePassword1 = true;

  var selectedLanguage = "Uz";
  final box = GetStorage();
  bool passwordsMatch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => RegBloc(),
        child: BlocListener<RegBloc, LoginState>(
          listener: (context, state) {
            if (state is CheckUserFailure) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Login Error'),
                    content: Text(state.message),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
            if (state is CheckUserSuccess) {
              // Delay the navigation to allow the build process to complete
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MapPage(),
                ),
              );
            }
          },
          child: BlocBuilder<RegBloc, LoginState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Image.asset('assets/142099.png'),
                        Center(
                            child: Text(
                              "sign_up".tr(),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            )),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _firstname,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter_first_name'.tr();
                            } else if (value.length < 3) {
                              return 'enter_first_name'.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'name'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _lastname,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter_last_name'.tr();
                            } else if (value.length < 3) {
                              return 'enter_last_name'.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'last_name'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: number,
                          inputFormatters: [maskFormatter],
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'tel'.tr(),
                            hintText: '998 90 000-00-00',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          obscureText: _obscurePassword,
                          controller: _password,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_password'.tr();
                            } else if (value.length < 4) {
                              return 'password_at_least_4_chars'.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'parol'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: _obscurePassword1,
                          controller: _passwordConfirm,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_password'.tr();
                            } else if (value.length < 4) {
                              return 'password_at_least_4_chars'.tr();
                            } else if (_password.text != _passwordConfirm.text) {
                              return 'please_enter_same_password'.tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'parol1'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscurePassword1 = !_obscurePassword1;
                                });
                              },
                              child: Icon(
                                _obscurePassword1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: colorGrey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Consumer(
                          builder: (context, ref, child) {
                            return SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(colorBlack),
                                  shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    String formattedPhoneNumber = number.text;

                                    // Remove non-numeric characters to get the original format
                                    String originalPhoneNumber =
                                    removeNonNumeric(formattedPhoneNumber);
                                    context.read<RegBloc>().add(CheckUserEvent(
                                      firstname: _firstname.text,
                                      lastname: _lastname.text,
                                      phone: originalPhoneNumber,
                                      password: _password.text,
                                    ));


                                  }
                                },
                                child: Text(
                                  "sign_up".tr(),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      )
    );
  }
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
