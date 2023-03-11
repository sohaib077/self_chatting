import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/modules/character_cubit/character_cubit.dart';
import 'package:chatting/modules/cubit/chatting_cubit.dart';
import 'package:chatting/modules/update_profile_screen/update_profile_screen.dart';
import 'package:chatting/shared/components/components.dart';
import 'package:chatting/shared/components/constants.dart';
import 'package:chatting/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/styles/icon_broken.dart';
import '../cubit/chatting_states.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var screenHeight =  MediaQuery.of(context).size.height ;
    var screenWidth =  MediaQuery.of(context).size.width ;

    return Builder(
        builder: (context) {
          // CharacterCubit.get(context).getMostChatting();

          return BlocConsumer<ChattingCubit, ChattingStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var userData = ChattingCubit
                  .get(context)
                  .userData;
              return Scaffold(
                floatingActionButton:
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    bottom: 10,
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      navigateTo(context, UpdateProfileScreen(), x: 0, y: 1);
                      ChattingCubit.get(context).isAvatarImage = false;
                      ChattingCubit.get(context).controller = 0;
                      ChattingCubit.get(context).profileImage = null;
                      ChattingCubit.get(context).coverImage = null;

                    },
                    child: Icon(
                      IconBroken.Edit,
                      size: screenHeight * 0.04,
                    ),
                    backgroundColor: defaultTealAccent,
                    elevation: 3,
                    highlightElevation: 0,
                    splashColor: Colors.tealAccent.withOpacity(0.5),

                  ),
                ),
                body: ConditionalBuilder(
                  condition: userData != null,
                  builder: (context) => Column(

                    children: [
                      Container(
                        height: screenHeight * 0.38,
                        width: screenWidth,
                        // color: defaultPurple,
                        child: Stack(
                          children: [
                            Container(
                              height: screenHeight * 0.3,

                              child: Stack(
                                children: [
                                  Container(
                                    height: screenHeight * 0.3,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      color: defaultTealAccent.withOpacity(1),
                                        image: DecorationImage(
                                          image:
                                          // NetworkImage(
                                          //   // 'https://img.freepik.com/premium-photo/astronaut-escape-from-void_146508-24.jpg?size=626&ext=jpg',
                                          //   '${ userData!.cover}',
                                          // ),
                                          userData!.cover == 'null' ?
                                          AssetImage(
                                            // 'https://img.freepik.com/premium-photo/astronaut-escape-from-void_146508-24.jpg?size=626&ext=jpg',
                                            'assets/images/cover.jpg',
                                          ):
                                              NetworkImage(
                                                  '${ userData.cover}',
                                              )  as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                        ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: Offset( 4 , 2),
                                          blurRadius: 5,
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: Offset( -4 , 1),
                                          blurRadius: 8,
                                        ),
                                      ]
                                    ),
                                  ),
                                  statusBar(context),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: CircleAvatar(
                                radius: screenHeight * 0.096,
                                backgroundColor: defaultWhite,
                                child: Transform(
                                     alignment: Alignment.center,
                                     transform: userData.image!.contains('char') && ! userData.image!.contains('image_cropper')  ? Matrix4.rotationY(pi) : Matrix4.rotationY(0),
                                  child: CircleAvatar(
                                  backgroundColor: defaultAvatar,
                                    radius: screenHeight * 0.09,
                                    backgroundImage: CachedNetworkImageProvider(
                                      // 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465',
                                      '${ userData.image}',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02,),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenHeight * 0.1),
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
                                fontSize: screenHeight * 0.025,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01,),
                            Text(
                              '${userData.bio}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                textBaseline: TextBaseline.alphabetic,
                                // fontFamily: 'schoolBook',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                fontSize: screenHeight * 0.025,
                              ),
                            ),
                            if(userData.type != null && userData.type != '' )
                              SizedBox(height: screenHeight * 0.01,),
                            if(userData.type != null && userData.type != '' )
                            Text(
                              '( ${userData.type} )',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                textBaseline: TextBaseline.alphabetic,
                                // fontFamily: 'schoolBook',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                fontSize: screenHeight * 0.025,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.07),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: screenHeight * 0.2,
                            width: screenWidth * 0.4,
                            decoration: BoxDecoration(
                              color: defaultWhite,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: defaultTealAccent.withOpacity(0.7),
                                  offset: Offset(-2, 3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Icon(
                                    IconBroken.User1,
                                    size: screenHeight * 0.04,
                                  ),
                                  SizedBox(height: screenHeight * 0.008,),
                                  FittedBox(
                                    child: Text(
                                      'Characters',
                                      style: TextStyle(
                                        fontFamily: 'schoolBook',
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenHeight * 0.03,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.015,),
                                  Text(
                                    '${CharacterCubit
                                        .get(context)
                                        .charSize}',
                                    style: TextStyle(
                                      fontFamily: 'schoolBook',
                                      fontWeight: FontWeight.w500,
                                      fontSize: screenHeight * 0.05,
                                      color: defaultPurple,

                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: screenHeight * 0.2,
                            width: screenWidth * 0.4,
                            decoration: BoxDecoration(
                              color: defaultWhite,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: defaultTealAccent.withOpacity(0.7),
                                  offset: Offset(-2, 3),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Icon(
                                    IconBroken.Heart,
                                    size: screenHeight * 0.04,
                                  ),
                                  SizedBox(height: screenHeight * 0.008,),
                                  FittedBox(
                                    child: Text(
                                      'Most Chatting',
                                      style: TextStyle(
                                        fontFamily: 'schoolBook',
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenHeight * 0.027,
                                        height: 1.5
                                        // fontSize: screenHeight * 0.2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.025,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CircleAvatar(
                                          radius: screenHeight*0.027,
                                          backgroundColor: defaultTealAccent.withOpacity(0.5),

                                        child: CircleAvatar(
                                          radius: screenHeight*0.025,
                                          backgroundColor: defaultAvatar,
                                          backgroundImage: CachedNetworkImageProvider(
                                            CharacterCubit.get(context).mostChatting.image != null?
                                            '${CharacterCubit.get(context).mostChatting.image}':
                                            '${CharacterCubit.get(context).charModel[0].image}',
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: screenWidth*0.2,
                                        child: Text(
                                            CharacterCubit.get(context).mostChatting.name != null?
                                          '${CharacterCubit.get(context).mostChatting.name}':
                                                '${CharacterCubit.get(context).charModel[0].name}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'schoolBook',
                                            fontWeight: FontWeight.w500,
                                            fontSize: screenHeight * 0.028,
                                            color: defaultPurple,

                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                  fallback: (context) => Center(child: CircularProgressIndicator(
                    color: defaultTealAccent,
                  )),
                ),
              );
            },
          );

        });
  }
}

class CustomClipPath extends CustomClipper<Path> {
  // var radius=5.0;
  @override
  Path getClip(Size size) {
    double w = size.width ;
    double h = size.height ;
    Path path = Path();
    // path.lineTo(size.width / 2, size.height);
    path.lineTo(0, h);
    path.quadraticBezierTo(
        w*0.5,
        h,
        w,
        h,
    );
        path.lineTo(w , 0);
        path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



  Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.08;


    Path path0 = Path();
    path0.moveTo(size.width*0.9991667,size.height*0.0028571);
    path0.lineTo(size.width,size.height*0.7128000);
    path0.quadraticBezierTo(size.width*0.7490417,size.height*0.2848000,size.width*0.4984417,size.height*0.7160143);
    path0.quadraticBezierTo(size.width*0.2056333,size.height*1.1438143,0,size.height*0.7147286);
    path0.lineTo(0,size.height*0.0014286);

    canvas.drawPath(path0, paint0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}


