import 'package:chatting/modules/cubit/chatting_cubit.dart';
import 'package:chatting/shared/components/components.dart';
import 'package:chatting/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/styles/icon_broken.dart';
import '../cubit/chatting_states.dart';

class UpdateProfileScreen extends StatelessWidget {

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController() ;
  var phoneController = TextEditingController() ;
  var bioController = TextEditingController() ;

  @override
  Widget build(BuildContext context) {

    var screenHeight =  MediaQuery.of(context).size.height ;
    var screenWidth =  MediaQuery.of(context).size.width ;



    bool isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return BlocConsumer<ChattingCubit , ChattingStates>(
      listener: (context , state){},
      builder: (context , state){

        var userData = ChattingCubit.get(context).userData ;
        var cubit = ChattingCubit.get(context) ;
        var profileImage = ChattingCubit.get(context).profileImage ;
        var coverImage = ChattingCubit.get(context).coverImage ;

        nameController.text = userData!.name!;
        phoneController.text = userData.phone!;
        bioController.text = userData.bio!;

        return  Scaffold(
          floatingActionButton: isKeyboardOpened ? null :
          FloatingActionButton.extended(
              onPressed: (){
                if(profileImage != null  && coverImage != null){
                  cubit.updateAllOfThem(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                  );
                }
                else if(profileImage != null  || coverImage != null){

                  if(profileImage != null){
                    cubit.uploadProfileImage(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                  }
                  else{
                    cubit.uploadCoverImage(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                  }
                }
                else{
                  cubit.updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text,
                  );
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
                        ),
                        child: Column(
                          children: [
                            underLineTextField(
                              controller: nameController,
                              validate: (String value){
                                if(value.isEmpty)
                                  return 'Please enter your name' ;
                              },

                              hintSize: screenHeight*0.022,
                              textSize: screenHeight*0.025,
                              prefixSize: screenHeight*0.038,
                              labelText: 'Name',
                              prefixIcon: IconBroken.Profile,
                              type: TextInputType.name,
                              // filled: true,
                              // fillColor: Colors.grey.shade100,
                              onSubmit: (value){
                                print(value) ;
                              }
                            ),

                            SizedBox(height: screenHeight*0.028,),

                            underLineTextField(
                              validate: (String value){
                                if(value.isEmpty)
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
                            SizedBox(height: screenHeight*0.028,),

                            underLineTextField(
                              validate: (String value){
                                if(value.isEmpty)
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

                            // SizedBox(height: screenHeight*0.04,),
                            // OutlinedButton(
                            //   onPressed: (){},
                            //   child: Row(
                            //     children: [
                            //       Text(
                            //         'UPdATE',
                            //         style: TextStyle(
                            //             color: defaultTealAccent,
                            //             fontSize: screenHeight*0.025,
                            //             fontWeight: FontWeight.bold,
                            //             letterSpacing: 2
                            //         ),
                            //       ),
                            //       Spacer(),
                            //       Icon(
                            //         IconBroken.Edit,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // MaterialButton(
                            //   onPressed: (){
                            //   },
                            //   color: defaultTealAccent.withOpacity(0.8),
                            //
                            //   // elevation: 0,
                            //   highlightColor: defaultTealAccent,
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10)),
                            //
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(15.0),
                            //     child: Row(
                            //       children: [
                            //         Expanded(
                            //           child: Text(
                            //             'UPDATE',
                            //             style: TextStyle(
                            //               color: Colors.white,
                            //               // fontSize: 25,
                            //               fontSize: screenHeight*0.033,
                            //               letterSpacing: 1.5 ,
                            //               fontWeight: FontWeight.bold,
                            //             ),
                            //           ),
                            //         ),
                            //         Icon(
                            //           IconBroken.Arrow___Right_2,
                            //           // size: 30,
                            //           size: screenHeight*0.035,
                            //           color: Colors.white,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            //
                            // ),
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
                              image: DecorationImage(
                                image: coverImage == null ?
                              NetworkImage(
                                  // 'https://img.freepik.com/premium-photo/astronaut-escape-from-void_146508-24.jpg?size=626&ext=jpg',
                                  '${ userData!.cover}',
                                ):
                                    FileImage(coverImage) as ImageProvider,
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
                              backgroundImage: profileImage == null ?
                              NetworkImage(
                                // 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465',
                                '${ userData!.image}'
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
                              cubit.getCoverImage();
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
                                cubit.getProfileImage();
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

                ],
              ),
            ),
          ),
        ) ;
      },
    );
  }
}
