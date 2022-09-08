import 'package:chatting/modules/cubit/chatting_cubit.dart';
import 'package:chatting/modules/cubit/chatting_states.dart';
import 'package:chatting/shared/styles/colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/styles/icon_broken.dart';

class ChattingLayout extends StatelessWidget {
  const ChattingLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var screenHeight =  MediaQuery.of(context).size.height ;
    var screenWidth =  MediaQuery.of(context).size.width ;

    return BlocConsumer<ChattingCubit , ChattingStates>(
      listener: (context , states){},
      builder: (context , states){

        var cubit = ChattingCubit.get(context) ;

        return Scaffold(
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(
                color: defaultWhite,
              ),
            ),
            child: CurvedNavigationBar(
              index: cubit.currentIndex,
              items: <Widget>[
                Icon(IconBroken.User1 , size: screenHeight*0.035,) ,
                Icon(IconBroken.Chat , size: screenHeight*0.035, ) ,
                Icon(IconBroken.Profile, size: screenHeight*0.035,) ,
              ],
              onTap: (index){
                cubit.changeBottomNav(index) ;
              },
              color: defaultTeal,
              backgroundColor: defaultWhite,
              buttonBackgroundColor: defaultPurple,
              animationDuration: Duration(milliseconds: 300),

              height: screenHeight*0.06,
            ),
          ),
          body: cubit.screens[cubit.currentIndex],

        ) ;
      },
    );
  }
}
