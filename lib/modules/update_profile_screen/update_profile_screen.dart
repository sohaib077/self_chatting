import 'dart:math';

import 'package:chatting/modules/character_cubit/character_states.dart';
import 'package:chatting/modules/cubit/chatting_cubit.dart';
import 'package:chatting/shared/components/components.dart';
import 'package:chatting/shared/styles/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/styles/icon_broken.dart';
import '../character_cubit/character_cubit.dart';
import '../cubit/chatting_states.dart';

class UpdateProfileScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController() ;
  var phoneController = TextEditingController() ;
  var bioController = TextEditingController() ;
  var typeController = TextEditingController() ;

  @override
  Widget build(BuildContext context) {

    var screenHeight =  MediaQuery.of(context).size.height ;
    var screenWidth =  MediaQuery.of(context).size.width ;



    bool isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;

    // return BlocConsumer<CharacterCubit , CharacterStates>(
    //   listener: (context , state){},
    //   builder: (context , state){
        return BlocConsumer<ChattingCubit , ChattingStates>(
        listener: (context , state){
          if(state is UpdateSuccessState)
            Navigator.pop(context);
        },
        builder: (context , state){

          var userData = ChattingCubit.get(context).userData ;
          var cubit = ChattingCubit.get(context) ;
          // var charCubit = CharacterCubit.get(context) ;
          var profileImage = ChattingCubit.get(context).profileImage ;
          var coverImage = ChattingCubit.get(context).coverImage ;

          if(cubit.controller == 0){
            nameController.text = userData!.name!;
            phoneController.text = userData.phone!;
            bioController.text = userData.bio!;
            if(userData.type != null)
            typeController.text = userData.type!;
          }


          return  GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              floatingActionButton: isKeyboardOpened ? null :
              FloatingActionButton.extended(
                  onPressed: (){

                    if(formKey.currentState!.validate()){
                      if(profileImage != null  && coverImage != null){
                        cubit.updateAllOfThem(
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          bio: bioController.text.trim(),
                            type: typeController.text.trim(),
                        );
                      }
                      else if(profileImage != null  || coverImage != null){

                        if(profileImage != null){
                          cubit.uploadProfileImage(
                            name: nameController.text.trim(),
                            phone: phoneController.text.trim(),
                            bio: bioController.text.trim(),
                            type: typeController.text.trim()
                          );
                        }
                        else{
                          cubit.uploadCoverImage(
                            name: nameController.text.trim(),
                            phone: phoneController.text.trim(),
                            bio: bioController.text.trim(),
                              type: typeController.text.trim()
                          );
                        }
                      }
                      else{
                        cubit.updateUser(
                          name: nameController.text.trim(),
                          phone: phoneController.text.trim(),
                          bio: bioController.text.trim(),
                            type: typeController.text.trim(),
                        );
                      }

                    }
                  },
                  label: Text(
                    'UPDATE',
                    style: TextStyle(
                      letterSpacing: 2 ,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                backgroundColor: defaultTealAccent,
                elevation: 3,
                highlightElevation: 0,
                splashColor: Colors.tealAccent.withOpacity(0.5),
              ),
              body: Form(
                key: formKey,
                child: Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          child: Padding(
                            padding:  EdgeInsetsDirectional.only(
                              start: screenHeight*0.08,
                              end: screenHeight*0.08,
                              top: screenHeight*0.4,
                              bottom: screenHeight*0.3,
                            ),
                            child: Column(
                              children: [
                                underLineTextField(
                                  controller: nameController,
                                  validate: (String value){
                                    if(value.trim().isEmpty)
                                      return 'Please enter your name' ;
                                  },

                                  hintSize: screenHeight*0.022,
                                  textSize: screenHeight*0.025,
                                  prefixSize: screenHeight*0.038,
                                  labelText: 'Name',
                                  prefixIcon: IconBroken.Profile,
                                  type: TextInputType.name,
                                    maxLength: 20,
                                  // filled: true,
                                  // fillColor: Colors.grey.shade100,
                                  onTap: (){
                                    cubit.controller = 1 ;
                                  }
                                ),

                                // SizedBox(height: screenHeight*0.02,),

                                underLineTextField(
                                  onTap: (){
                                    cubit.controller = 1 ;
                                  },
                                  validate: (String value){
                                    if(value.trim().isEmpty)
                                      return 'Please enter your Bio' ;
                                  },

                                  hintSize: screenHeight*0.022,
                                  textSize: screenHeight*0.025,
                                  prefixSize: screenHeight*0.038,

                                  labelText: 'Bio...',
                                  prefixIcon: IconBroken.Paper,
                                  // fillColor: Colors.grey.shade100,
                                  // filled: true ,
                                  type: TextInputType.text,
                                  controller: bioController,

                                ),

                                SizedBox(height: screenHeight*0.02,),

                            underLineTextField(
                              onTap: (){
                                cubit.controller = 1 ;
                              },
                              validate: (String value){
                                // if(value.trim().isEmpty)
                                //   return 'Please enter your phone' ;
                              },

                              onChange: (value){
                                // autoValidate = false ;
                              },

                              hintSize: screenHeight*0.022,
                              textSize: screenHeight*0.025,
                              prefixSize: screenHeight*0.04,
                                  labelText: 'Type',
                              hintText: 'Personality Type',
                              prefixIcon: IconBroken.User1,
                              type: TextInputType.text,
                              // filled: true,
                              // fillColor: Colors.grey.shade100,
                              controller: typeController,
                              suffix: true,
                              suffixIcon: IconBroken.Info_Circle,
                              suffixColor: defaultGrey,
                              suffixPress: (){
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text(
                                          'What are personality types !',
                                          style: TextStyle(
                                            letterSpacing: 1,
                                            height: 0,
                                            fontFamily: 'schoolBook',
                                            fontSize: screenHeight*0.025,
                                            fontWeight: FontWeight.w600,
                                            color: defaultTeal,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        content: RichText(
                                          text: TextSpan(
                                            text: 'personality type refers to the psychological classification of different types of individuals.\n\nSocionics divides people into 16 different types, called sociotypes which are:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.5,
                                                height: 1.25,
                                                color: Colors.black87,
                                                fontSize: 12
                                            ),
                                            children:  [
                                              TextSpan(
                                                text: '\n\n- ESTJ       - ENTJ       - ESFJ       - ENFJ      \n- ISTJ        - ISFJ        - INTJ        - INFJ      \n- ESTP      - ESFP       - ENTP      - ENFP      \n- ISTP       - ISFP        - INTP       - INFP      \n',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.5,
                                                  height: 1.5,
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                ),

                                              ),
                                              TextSpan(
                                                text: '\nYou can know your type from:\n',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.5,
                                                  height: 1.5,
                                                  color: Colors.black87,
                                                ),


                                              ),
                                              TextSpan(
                                                text: ' https://www.16personalities.com/personality-types \n',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  letterSpacing: 0.5,
                                                  height: 1.5,
                                                  color: Colors.blue,
                                                  fontSize: 10.5,
                                                  decoration: TextDecoration.underline,
                                                ),
                                                recognizer: TapGestureRecognizer()..onTap = () =>_launchUrl(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        contentPadding: EdgeInsetsDirectional.only(
                                          start: 30,
                                          end: 30,
                                          top: 12,
                                          bottom: 12,
                                        ),
                                      );
                                    }
                                );
                              },
                              onSubmit: (value){},

                            ),

                              SizedBox(height: screenHeight*0.02,),

                                underLineTextField(
                                  onTap: (){
                                    cubit.controller = 1 ;
                                  },
                                  validate: (String value){
                                    if(value.trim().isEmpty)
                                      return 'Please enter your phone' ;
                                  },

                                  hintSize: screenHeight*0.022,
                                  textSize: screenHeight*0.025,
                                  prefixSize: screenHeight*0.038,

                                  labelText: 'Phone',
                                  prefixIcon: IconBroken.Call,
                                  type: TextInputType.phone,
                                  // filled: true,
                                  // fillColor: Colors.grey.shade100,
                                  controller: phoneController,

                                ),


                                // if(state is UpdateLoadingState)
                                // SizedBox(height: screenHeight*0.02,),
                                //
                                // if(state is UpdateLoadingState)
                                //   LinearProgressIndicator(
                                //     color: defaultTealAccent,
                                //     backgroundColor: Colors.transparent,
                                //     minHeight: screenHeight*0.004,
                                //   ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Container(
                        height: screenHeight*0.38,
                        width: screenWidth,
                        // color: defaultPurple,
                        child: Stack(
                          children: [
                            Container(
                              height: screenHeight*0.3,
                              child: Stack(
                                children: [
                                  Container(
                                    height: screenHeight*0.3,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                        color: defaultTealAccent.withOpacity(1),
                                        image: DecorationImage(
                                          image: coverImage == null ?
                                              userData!.cover == 'null' ?
                                                  AssetImage('assets/images/cover.jpg'):
                                        NetworkImage(
                                            // 'https://img.freepik.com/premium-photo/astronaut-escape-from-void_146508-24.jpg?size=626&ext=jpg',
                                            '${ userData!.cover}',
                                          ) as ImageProvider :
                                              FileImage(coverImage) as ImageProvider,
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
                                      ],
                                    ),
                                  ),
                                  Container(
                                      height: MediaQuery.of(context).viewPadding.top,
                                      color: defaultWhite.withOpacity(0.3),
                                    ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: CircleAvatar(
                                radius: screenHeight*0.086,
                                backgroundColor: defaultWhite,
                                child: Transform(
                                   alignment: Alignment.center,
                                   transform: cubit.isAvatarImage || userData!.image!.contains('char') && ! userData.image!.contains('image_cropper') && profileImage == null ? Matrix4.rotationY(pi) : Matrix4.rotationY(0),
                                  child: CircleAvatar(
                                    backgroundColor: defaultAvatar,
                                    radius: screenHeight*0.08,
                                    backgroundImage:
                                    ! cubit.isAvatarImage && profileImage == null?
                                      NetworkImage(
                                    '${ userData!.image}'
                                  ) :
                                     profileImage != null ?
                                        FileImage(profileImage) as ImageProvider :
                                          AssetImage(cubit.avatarImage),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsetsDirectional.only(
                                top: screenHeight*0.045,
                                start: screenHeight*0.01,
                              ),
                              child: FloatingActionButton.small(
                                heroTag: "back",
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  IconBroken.Arrow___Left_2,
                                  size: screenHeight*0.04,
                                  color: defaultTealAccent,
                                ),
                                backgroundColor: defaultWhite,
                                elevation: 3,
                                highlightElevation: 0,
                                splashColor: Colors.tealAccent,

                              ),
                            ),
                            Padding(
                              padding:  EdgeInsetsDirectional.only(
                                top: screenHeight*0.2,
                                start: screenWidth*0.84,
                              ),
                              child: FloatingActionButton(
                                heroTag: "cover",
                                onPressed: (){
                                  cubit.getCoverImage(context);
                                },
                                child: Icon(
                                  IconBroken.Camera,
                                  size: screenHeight*0.044,
                                  color: defaultTealAccent,
                                ),
                                backgroundColor: defaultWhite,
                                elevation: 3,
                                highlightElevation: 0,
                                splashColor: Colors.tealAccent,

                              ),
                            ),
                            Padding(
                              padding:  EdgeInsetsDirectional.only(
                                top: screenHeight*0.32,
                                start: screenWidth*0.54,
                              ),
                              child: FloatingActionButton.small(
                                heroTag: "profile",
                                onPressed: (){
                                    cubit.getProfileImage(context);
                                },
                                child: Icon(
                                  IconBroken.Camera,
                                  size: screenHeight*0.035,
                                  color: defaultTealAccent,
                                ),
                                backgroundColor: defaultWhite,
                                elevation: 3,
                                highlightElevation: 0,
                                splashColor: Colors.tealAccent,

                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight*0.02,),
                      Padding(
                              padding:  EdgeInsetsDirectional.only(
                                start: screenHeight*0.02,
                                // bottom: screenHeight*0.1,
                                end: screenHeight*0.02,
                                top: screenHeight*0.75,
                              ),
                        child: Container(
                          color: defaultWhite.withOpacity(0.9),
                        ),
                      ),

                        if(state is  UpdateLoadingState || state is UpdateCoverSuccessState
                        )
                          Padding(
                                padding:  EdgeInsetsDirectional.only(
                                  start: screenHeight*0.08,
                                  end: screenHeight*0.08,
                                    top: screenHeight*0.75,
                                ),
                                child: LinearProgressIndicator(
                                          color: defaultTealAccent,
                                          backgroundColor: Colors.transparent,
                                          minHeight: screenHeight*0.004,
                                      ),
                                  ),

                      Padding(
                            padding:  EdgeInsetsDirectional.only(
                              start: screenHeight*0.02,
                              bottom: screenHeight*0.1,
                              end: screenHeight*0.02,
                              top: screenHeight*0.77,
                            ),
                        child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                    itemBuilder: (context , index) => charItem(index, context),
                                    separatorBuilder: (context , index) => SizedBox(width: screenWidth*0.048,),
                                    itemCount: 15
                                ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ) ;
        },
      );
    //   },
    // );
  }

  final Uri _url = Uri.parse('https://www.16personalities.com/free-personality-test');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

    Widget charItem(index , context ,) => CircleAvatar(
      radius: MediaQuery.of(context).size.height*0.057,
      backgroundColor: defaultTealAccent.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.005),
            child: InkWell(
              onTap: (){
                ChattingCubit.get(context).isAvatarImage = true ;
                ChattingCubit.get(context).profileImage = null ;
                ChattingCubit.get(context).changeAvatarIndex(index: index);
              },
              radius: MediaQuery.of(context).size.height*0.055,
              customBorder: CircleBorder(),
              child: Transform(
                 alignment: Alignment.center,
                   transform: Matrix4.rotationY(pi),
                child: Image(
                  image:AssetImage(
                  'assets/images/characters/char${index+1}.png',
                  // '${ userData!.image}'
                ),
                      color: Colors.white,
                      colorBlendMode: BlendMode.modulate,
                ),
              ),
            ),
          ),
          if(index == ChattingCubit.get(context).avatarIndex && ChattingCubit.get(context).profileImage == null && ChattingCubit.get(context).isAvatarImage)
          LinearProgressIndicator(
              color: defaultTealAccent.withOpacity(0.7),
            backgroundColor: Colors.transparent,
            minHeight:  MediaQuery.of(context).size.height*0.004,
            ),

        ],
      ),
    );


}