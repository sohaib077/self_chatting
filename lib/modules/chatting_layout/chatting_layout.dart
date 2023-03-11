import 'package:chatting/modules/character_cubit/character_cubit.dart';
import 'package:chatting/modules/cubit/chatting_cubit.dart';
import 'package:chatting/modules/cubit/chatting_states.dart';
import 'package:chatting/modules/login_cubit/states.dart';
import 'package:chatting/shared/components/components.dart';
import 'package:chatting/shared/styles/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../shared/components/constants.dart';
import '../../shared/remote/cache_helper.dart';
import '../../shared/styles/icon_broken.dart';
import '../character_cubit/character_states.dart';
import '../login_cubit/login_cubit.dart';

class ChattingLayout extends StatefulWidget {


  @override
  State<ChattingLayout> createState() => _ChattingLayoutState();
}

class _ChattingLayoutState extends State<ChattingLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('chattingLayout initState');
    print('from chatting layout $uId');

    InternetConnectionChecker().onStatusChange.listen((status) {
      if(status == InternetConnectionStatus.disconnected) {

        for(int i=0 ; i < 2 ; i++)
          showToast(text: 'Check your internet connection', state: ToastStates.ERROR);

      }
      else {
        showToast(text: 'Connected', state: ToastStates.SUCCESS);
        // setState(() {});
        // setState(() {});
      }


    });
    // CharacterCubit.get(context).numberOfChats();

  }
  Widget build(BuildContext context) {

    // CharacterCubit.get(context).getCharacters();
    // ChattingCubit.get(context).getUserData();
    // var screenWidth =  MediaQuery.of(context).size.width ;

    // uId = CasheHelper.getData('uId') ?? ' ' ;
    // print('uid....... \n $uId');




    // return BlocConsumer<LoginCubit , LoginStates>(
    //   listener: (context , state){},
    //   builder: (context , state){
        // return BlocConsumer<CharacterCubit , CharacterStates>(
        //   listener: (context , state){},
        //   builder: (context , state){
        //
          var screenHeight =  MediaQuery.of(context).size.height ;

            return Builder(
              builder: (context) {
                // CharacterCubit.get(context).getLastMessages();


                return BlocConsumer<ChattingCubit, ChattingStates>(

                  listener: (context, states) {},
                  builder: (context, states) {
                    var cubit = ChattingCubit.get(context);

                    // return BlocConsumer<CharacterCubit, CharacterStates>(
                    //   listener: (context, state) {},
                    //   builder: (context, state) {
                        return Scaffold(
                          resizeToAvoidBottomInset: false,
                          // backgroundColor: Colors.black87,
                          // appBar: AppBar(
                          //   systemOverlayStyle: SystemUiOverlayStyle(
                          //       // statusBarColor: Colors.transparent,
                          //       // statusBarColor: Colors.transparent,
                          //       statusBarIconBrightness: Brightness.dark,
                          //   ),
                          //   toolbarHeight: 0,
                          //   foregroundColor: Colors.transparent,
                          //   shadowColor: Colors.transparent,
                          //   surfaceTintColor: Colors.transparent,
                          //   backgroundColor: Colors.transparent,
                          // ),
                          bottomNavigationBar: Theme(
                            data: Theme.of(context).copyWith(
                              iconTheme: IconThemeData(
                                color: defaultWhite,
                              ),
                            ),
                            child: CurvedNavigationBar(
                              index: cubit.currentIndex,
                              items: <Widget>[
                                Icon(IconBroken.User1, size: screenHeight * 0.035,),
                                Icon(IconBroken.Chat, size: screenHeight * 0.035,),
                                Icon(IconBroken.Profile, size: screenHeight * 0.035,),
                              ],
                              onTap: (index) {
                                cubit.changeBottomNav(index);
                              },
                              color: defaultTeal,
                              backgroundColor: defaultWhite,
                              buttonBackgroundColor: defaultPurple,
                              animationDuration: Duration(milliseconds: 300),

                              height: screenHeight * 0.06,
                            ),
                          ),

                          body: cubit.screens[cubit.currentIndex],

                        );
                      },
                    );
                  },
                );
              // });
          // },
        // );
    //   },
    // );
  }
}
