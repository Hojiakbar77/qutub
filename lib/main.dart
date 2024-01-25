import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:qutub/home.dart';
import 'package:qutub/screen/sign_up.dart';

import 'blocs/location/location_bloc.dart';
import 'blocs/reg/reg_bloc.dart';
import 'screen/map.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();
  runApp(ProviderScope(
      child: EasyLocalization(
          startLocale: const Locale("uz"),
          path: 'assets/translations',
          supportedLocales: const [
            Locale(
              "ru",
            ),
            Locale(
              "uz",
            ),
          ],
          child: const MyApp())));
}
final box = GetStorage();
late Widget current;


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    dynamic token= box.read("accessToken");
    bool isTokenValid = token != null && token.isNotEmpty;
    final locale = EasyLocalization.of(context)!.locale;
    return MaterialApp(

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: locale,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          BlocProvider<LocationBloc>(
            create: (context) => LocationBloc(),
          ),
          BlocProvider<RegBloc>(
            create: (context) => RegBloc(),
          ),
          // Add other providers if any
        ],
        child:  isTokenValid?const MapPage():const HomePage(), // Your MapPage or initial route
      ),

    );
  }
}


