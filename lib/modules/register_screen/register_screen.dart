import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/remote/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';
import '../home_screen/home_screen.dart';
import '../login_cubit/login_cubit.dart';
import '../login_cubit/states.dart';

class RegisterScreen extends StatelessWidget {

  // TextEditingController ? passwordController ;
  // TextEditingController ? emailController ;
  // TextEditingController ? nameController ;
  // TextEditingController ? phoneController ;

  var nameController = TextEditingController() ;
  var phoneController = TextEditingController() ;
  var emailController = TextEditingController() ;
  var passwordController = TextEditingController() ;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var screenHeight =  MediaQuery.of(context).size.height ;
    var screenWidth =  MediaQuery.of(context).size.width ;

    return BlocConsumer<LoginCubit , LoginStates>(
      listener: (context, state){
        if(state is RegisterErrorState){
          showToast(text: state.error, state: ToastStates.ERROR);
        }

        if(state is CreateUserSuccessState){
          CasheHelper.saveData(key: 'uId', value: state.uId).then((value) {

          }).catchError((error){
            print('Error while saving uId \n ' + error.toString()) ;
          });
        }

      },
      builder: (context, state){

        LoginCubit cubit = LoginCubit.get(context) ;

        return  Container(
          // color: Colors.teal,
          decoration: BoxDecoration(
            color: Color(0xffe9edef),
            image: DecorationImage(
              image: AssetImage('assets/images/register 1.png' ),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  IconBroken.Arrow___Left_2,
                  size: screenHeight*0.035,
                ),
                onPressed: (){
                  Navigator.pop(context);
                } ,
              ),
            ),
            body: Form(
              key: formKey,
              child: Container(
                child: Stack(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsetsDirectional.only(
                    //     top: 20,
                    //     start: 40,
                    //   ),
                    //   child: Text(
                    //     'Create\nAccount',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 30,
                    //       fontWeight: FontWeight.normal,
                    //     ),
                    //   ),
                    // ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsetsDirectional.only(
                          top: MediaQuery.of(context).size.height*0.35,
                          start: 40,
                          end: 40,
                        ),
                        child: Column(
                          children: [
                            underLineTextField(
                              hintSize: screenHeight*0.022,
                              textSize: screenHeight*0.025,
                              prefixSize: screenHeight*0.033,

                              hintText: 'Name',
                              prefixIcon: IconBroken.Profile,
                              type: TextInputType.name,
                              // filled: true,
                              // fillColor: Colors.grey.shade100,
                              controller: nameController,
                              validate: (String value){
                                if(value.isEmpty)
                                  return 'Please enter your name' ;
                              }
                            ),
                            SizedBox(height: screenHeight*0.028,),

                            underLineTextField(
                              hintSize: screenHeight*0.022,
                              textSize: screenHeight*0.025,
                              prefixSize: screenHeight*0.033,

                              hintText: 'Phone',
                              prefixIcon: IconBroken.Call,
                              type: TextInputType.phone,
                              // filled: true,
                              // fillColor: Colors.grey.shade100,
                              controller: phoneController,
                                validate: (String value){
                                  if(value.isEmpty)
                                    return 'Please enter your phone' ;
                                }
                            ),
                            SizedBox(height: screenHeight*0.028,),

                            underLineTextField(
                              hintSize: screenHeight*0.022,
                              textSize: screenHeight*0.025,
                              prefixSize: screenHeight*0.033,

                              hintText: 'Email Address',
                              prefixIcon: IconBroken.Message,
                              // fillColor: Colors.grey.shade100,
                              // filled: true ,
                              type: TextInputType.emailAddress,
                              controller: emailController,
                                validate: (String value){
                                  if(value.isEmpty)
                                    return 'Please enter an available email' ;
                                }

                            ),

                            SizedBox(height: screenHeight*0.028,),

                            underLineTextField(
                              hintSize: screenHeight*0.022,
                              textSize: screenHeight*0.025,
                              prefixSize: screenHeight*0.033,
                              suffixSize: screenHeight*0.03,
                              hintText: 'Password',
                              prefixIcon: IconBroken.Lock ,
                              suffixIcon: cubit.passIcon,
                              obscure: cubit.isShown,
                              // fillColor: Colors.grey.shade100,
                              suffix: true,
                              // filled: true ,
                              type: TextInputType.visiblePassword,
                              controller: passwordController,
                              suffixPress: (){
                                cubit.passwordVisibility();
                              },
                                validate: (String value){
                                  if(value.isEmpty)
                                    return 'Please enter an available password' ;
                                },

                            ),

                            SizedBox(height: screenHeight*0.06,),

                            Container(
                              width: MediaQuery.of(context).size.width*0.5,
                              child: MaterialButton(
                                onPressed: (){
                                  if (formKey.currentState!.validate()) {
                                    cubit.register(
                                      name: nameController.text.trim(),
                                      phone: phoneController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      context: context,
                                    );
                                  }
                                },
                                color: defaultPurple,

                                // elevation: 0,
                                highlightColor: defaultPurple.withOpacity(0.85),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),

                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Sign up',
                                          style: TextStyle(
                                            color: Colors.white,
                                            // fontSize: 25,
                                            fontSize: screenHeight*0.033,
                                            letterSpacing: 1.5 ,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        IconBroken.Arrow___Right_2,
                                        // size: 30,
                                        size: screenHeight*0.035,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ),
                            if (state is RegisterLoadingState )
                              Container(
                                padding: EdgeInsetsDirectional.only(top: 5),
                                width: MediaQuery.of(context).size.width*0.48,
                                child: LinearProgressIndicator(
                                  color: defaultTealAccent,
                                ),
                              ),


                            // Row(
                            //   children: [
                            //     Text(
                            //       'Sign In',
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 30,
                            //       ),
                            //     ),
                            //     Spacer(),
                            //     InkWell(
                            //       onTap: () {
                            //         if (formKey.currentState!.validate()) {
                            //           cubit.register(
                            //             name: nameController.text,
                            //             phone: phoneController.text,
                            //             email: emailController.text,
                            //             password: passwordController.text,
                            //             context: context,
                            //           );
                            //         }
                            //       },
                            //       customBorder: CircleBorder(),
                            //       highlightColor: Colors.black,
                            //       child: CircleAvatar(
                            //         radius: 30,
                            //         backgroundColor: Color(0xff4c505b).withOpacity(0.95),
                            //         child:  Padding(
                            //           padding: const EdgeInsetsDirectional.only(end: 5),
                            //           child: Icon(
                            //             // Icons.arrow_forward_ios_outlined,
                            //             IconBroken.Login,
                            //             color: Colors.white ,
                            //             size: 35,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //
                            //   ],
                            // ),




                          ],
                        ),
                      ),
                    )

                  ],
                ),

              ),
            ),
          ),
        );
      },
    );
  }
}
