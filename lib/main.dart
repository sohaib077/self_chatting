import 'package:chatting/modules/chatting_layout/chatting_layout.dart';
import 'package:chatting/modules/cubit/chatting_cubit.dart';
import 'package:chatting/modules/home_screen/home_screen.dart';
import 'package:chatting/modules/login_screen/login_screen.dart';
import 'package:chatting/shared/bloc_observer.dart';
import 'package:chatting/shared/components/constants.dart';
import 'package:chatting/shared/remote/cache_helper.dart';
import 'package:chatting/shared/styles/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/login_cubit/login_cubit.dart';
import 'modules/login_cubit/states.dart';

void main() async
{

  WidgetsFlutterBinding.ensureInitialized();

  await CasheHelper.init();

  await Firebase.initializeApp();

  uId = CasheHelper.getData('uId') ?? ' ' ;
  print(uId);

  BlocOverrides.runZoned(
        () {
      // Use cubits...
      runApp( const MyApp() );},
    blocObserver: MyBlocObserver(),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => ChattingCubit()..getUserData()),

      ],
      child: MaterialApp(
              theme: ThemeData(
                scaffoldBackgroundColor: defaultWhite,
                fontFamily: 'perpetua',
                appBarTheme: AppBarTheme(
                  titleTextStyle: TextStyle(
                    color: defaultTeal,
                    fontSize: 24,
                    fontFamily: 'schoolBook',
                  ),
                  color: Colors.transparent,
                  elevation: 0,
                  systemOverlayStyle: SystemUiOverlayStyle(
                    // statusBarColor: defaultTeal,
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                ),
              ),
              debugShowCheckedModeBanner: false,
              home: uId == ' ' ?  LoginScreen() : ChattingLayout(),
            ),
       );
    }

  }

