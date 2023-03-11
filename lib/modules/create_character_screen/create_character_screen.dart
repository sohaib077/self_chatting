import 'package:chatting/modules/character_cubit/character_cubit.dart';
import 'package:chatting/modules/character_cubit/character_states.dart';
import 'package:chatting/modules/cubit/chatting_cubit.dart';
import 'package:chatting/shared/components/components.dart';
import 'package:chatting/shared/styles/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/components/constants.dart';
import '../../shared/styles/icon_broken.dart';
import '../cubit/chatting_states.dart';



class CreateCharacterScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController() ;
  var typeController = TextEditingController() ;
  var bioController = TextEditingController() ;


  @override
  Widget build(BuildContext context) {



    var screenHeight =  MediaQuery.of(context).size.height ;
    var screenWidth =  MediaQuery.of(context).size.width ;

    bool isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return BlocConsumer<CharacterCubit ,CharacterStates>(
      listener: (context , state){
        if(state is GetCharactersSuccessState) {
          Navigator.pop(context);
          CharacterCubit.get(context).avatarIndex = 0 ;
          CharacterCubit.get(context).avatarImage = 'assets/images/characters/char1.png' ;

        }
        // CharacterCubit.get(context).characterProfileImage = null ;

      },
      builder: (context , state){

        // var userData = ChattingCubit.get(context).userData ;
        // var cubit = ChattingCubit.get(context) ;
        // var profileImage = ChattingCubit.get(context).profileImage ;
        // var coverImage = ChattingCubit.get(context).coverImage ;

        var cubit = CharacterCubit.get(context) ;
        var profileImage = CharacterCubit.get(context).characterProfileImage ;
        var coverImage = CharacterCubit.get(context).characterCoverImage ;

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
              heroTag: 'create1',
                onPressed: () {
                  // cubit.test();
                  if (formKey.currentState!.validate()) {
                      cubit.uploadProfileImage(
                        name: nameController.text,
                        bio: bioController.text,
                        // context: context,
                        type: typeController.text,
                      );

                  }

                },
                label: Text(
                  'CREATE',
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
                            top: screenHeight*0.42,
                          ),
                          child: Column(
                            children: [
                              underLineTextField(
                                autoValidate: true,
                                controller: nameController,
                                onChange: (value){
                                    // autoValidate = true ;
                                  // print(value.toString());
                                  // autoValidate = true ;
                                },
                                  onSubmit: (value){
                                  // autoValidate = false ;
                                  },

                                validate: (String value){

                                  if(value.trim().isEmpty) {
                                    return 'Please enter your Nickname' ;
                                  }
                                  if(cubit.checkIfExist(value.trim()) == 'true') {
                                    return 'This nickname is already token by another character.';
                                  }

                                },

                                hintSize: screenHeight*0.022,
                                textSize: screenHeight*0.025,
                                prefixSize: screenHeight*0.038,
                                hintText: 'Nickname',
                                prefixIcon: IconBroken.Profile,
                                type: TextInputType.name,
                                // filled: true,
                                // fillColor: Colors.grey.shade100,
                                onTap: (){
                                  // cubit.controller = 1 ;
                                },
                                maxLength: 20,
                              ),

                              // SizedBox(height: screenHeight*0.028,),


                              underLineTextField(
                                onTap: (){
                                  // cubit.controller = 1 ;
                                },
                                validate: (String value){
                                  if(value.trim().isEmpty)
                                    return 'Please enter your Bio' ;
                                },

                                hintSize: screenHeight*0.022,
                                textSize: screenHeight*0.025,
                                prefixSize: screenHeight*0.038,

                                hintText: 'Bio...',
                                prefixIcon: IconBroken.Paper,
                                // fillColor: Colors.grey.shade100,
                                // filled: true ,
                                type: TextInputType.text,
                                controller: bioController,
                                onChange:   (value){
                                  // autoValidate = false ;
                                },
                                onSubmit: (value){},



                              ),

                              SizedBox(height: screenHeight*0.028,),

                              underLineTextField(
                                onTap: (){
                                  // cubit.controller = 1 ;
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
                                          return alertDialog(screenHeight ,_launchUrl);
                                        }
                                    );
                                },
                                onSubmit: (value){},

                              ),

                              if(state is CreateCharacterLoadingState)
                              SizedBox(height: screenHeight*0.02,),
                              if(state is CreateCharacterLoadingState)
                                LinearProgressIndicator(
                                  color: defaultTealAccent,
                                  backgroundColor: Colors.transparent,
                                  minHeight: screenHeight*0.004,
                                ),
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
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: defaultTealAccent.withOpacity(0.8),
                                image: DecorationImage(
                                  image: coverImage == null ?
                                // NetworkImage(
                                //     'https://img.freepik.com/premium-photo/astronaut-escape-from-void_146508-24.jpg?size=626&ext=jpg',
                                //     // '${ userData!.cover}',
                                //   ):
                                AssetImage(
                                    'assets/images/cover.jpg',
                                    // '${ userData!.cover}',
                                  ):
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
                                ]
                            ),
                          ),
                          statusBar(context),

                          Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: CircleAvatar(
                              radius: screenHeight*0.086,
                              backgroundColor: defaultWhite,
                              child: CircleAvatar(
                                radius: screenHeight*0.08,
                                backgroundColor: defaultAvatar,
                                backgroundImage: profileImage == null ?
                                // NetworkImage(
                                //   'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465',
                                //   // '${ userData!.image}'
                                // ) :
                                AssetImage(
                                  // 'assets/images/characters/char1.png',
                                  cubit.avatarImage,
                                  // '${ userData!.image}'
                                ) :
                                    FileImage(profileImage) as ImageProvider ,
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsetsDirectional.only(
                              top: screenHeight*0.045,
                              start: screenHeight*0.01,
                            ),
                            child: FloatingActionButton.small(
                              heroTag: "back1",
                              onPressed: (){
                                Navigator.pop(context);
                                cubit.avatarIndex = 0 ;
                                cubit.avatarImage = 'assets/images/characters/char1.png' ;
                                CharacterCubit.get(context).characterProfileImage = null ;
                                CharacterCubit.get(context).characterCoverImage = null ;
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
                              top: screenHeight*0.22,
                              start: screenWidth*0.84,
                            ),
                            child: FloatingActionButton(
                              heroTag: "cover1",
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
                              heroTag: "profile1",
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
                            bottom: screenHeight*0.1,
                            end: screenHeight*0.02,
                            top: screenHeight*0.72,
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
              CharacterCubit.get(context).characterProfileImage = null ;
              CharacterCubit.get(context).changeAvatarIndex(index: index);
            },
            radius: MediaQuery.of(context).size.height*0.055,
            customBorder: CircleBorder(),
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
        if(index == CharacterCubit.get(context).avatarIndex && CharacterCubit.get(context).characterProfileImage == null)
        LinearProgressIndicator(
            color: defaultTealAccent.withOpacity(0.7),
          backgroundColor: Colors.transparent,
          minHeight:  MediaQuery.of(context).size.height*0.004,
          ),

      ],
    ),
        );
}




