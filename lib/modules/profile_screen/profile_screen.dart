import 'package:chatting/modules/cubit/chatting_cubit.dart';
import 'package:chatting/modules/update_profile_screen/update_profile_screen.dart';
import 'package:chatting/shared/components/components.dart';
import 'package:chatting/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/styles/icon_broken.dart';
import '../cubit/chatting_states.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var screenHeight =  MediaQuery.of(context).size.height ;
    var screenWidth =  MediaQuery.of(context).size.width ;

    return BlocConsumer<ChattingCubit , ChattingStates>(
      listener: (context , state){},
      builder: (context , state){

        var userData = ChattingCubit.get(context).userData ;
        return  Scaffold(
          // appBar: AppBar(
          //   title: Text(
          //     'Profile',
          //   ),
          // ),
          floatingActionButton:
          Padding(
            padding: const EdgeInsetsDirectional.only(
                bottom: 10 ,
            ),
            child: FloatingActionButton(
              onPressed: (){
                navigateTo(context, UpdateProfileScreen() , x: 0 , y: 1);
              },
              child: Icon(
                IconBroken.Edit,
                size: screenHeight*0.04,
              ),
              backgroundColor: defaultTealAccent,
              elevation: 3,
              highlightElevation: 0,
              splashColor: Colors.tealAccent.withOpacity(0.5),

            ),
          ),
          body: Column(
            children: [
              Container(
                height: screenHeight*0.38,
                width: screenWidth,
                // color: defaultPurple,
                child: Stack(
                  children: [
                    Container(
                      height: screenHeight*0.3,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              // 'https://img.freepik.com/premium-photo/astronaut-escape-from-void_146508-24.jpg?size=626&ext=jpg',
                             '${ userData!.cover}',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: CircleAvatar(
                        radius: screenHeight*0.086,
                        backgroundColor: defaultWhite,
                        child: CircleAvatar(
                          radius: screenHeight*0.08,
                          backgroundImage:   NetworkImage(
                            // 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465',
                            '${ userData.image}',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.02,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal:screenHeight*0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${userData.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'schoolBook',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        fontSize: screenHeight*0.025,
                      ),
                    ),
                    SizedBox(height: screenHeight*0.01,),
                    Text(
                      '${userData.bio}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        textBaseline: TextBaseline.alphabetic,
                        // fontFamily: 'schoolBook',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        fontSize: screenHeight*0.025,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.05),
            ],
          ),
        ) ;
      },
    );
  }
}
