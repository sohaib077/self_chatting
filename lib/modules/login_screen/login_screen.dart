
import 'package:chatting/shared/remote/cache_helper.dart';
import 'package:chatting/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/icon_broken.dart';
import '../login_cubit/login_cubit.dart';
import '../login_cubit/states.dart';
import '../register_screen/register_screen.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var formKey = GlobalKey<FormState>();
  var emailController  = TextEditingController() ;
  var passwordController  = TextEditingController() ;


  @override
  Widget build(BuildContext context) {

    var screenHeight =  MediaQuery.of(context).size.height ;
    var screenWidth =  MediaQuery.of(context).size.width ;

    return BlocConsumer<LoginCubit , LoginStates>(
      listener: (context, state){
        if(state is LoginErrorState){
          showToast(text: state.error, state: ToastStates.ERROR);
        }

        if(state is LoginSuccessState){
          CasheHelper.saveData(key: 'uId', value: state.uId).then((value) {

          }).catchError((error){
            print('Error while saving uId \n ' + error.toString()) ;
          });
        }
      },
      builder: (context, state){

        LoginCubit cubit = LoginCubit.get(context);

        return  Container(
          decoration: BoxDecoration(
            color: Color(0xffe9edef),
            image:  DecorationImage(
                  image: AssetImage(
                      'assets/images/login 1.png' ,
                  ),
              fit: BoxFit.cover,
            ) ,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(),
            body: Stack(
                children: [
                  Container(
                    padding:  EdgeInsetsDirectional.only( top: screenHeight*0.12 , start: screenWidth*0.04),
                    child: Text(
                      'Welcome\n  B a c k',
                      style: TextStyle(
                        // fontSize: 33,
                        letterSpacing: 1.5,
                        height: 1.2,
                        fontSize: screenHeight*0.045,
                        color: Colors.white,
                        fontFamily: 'schoolBook' ,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Container(
                        padding:  EdgeInsetsDirectional.only(
                          top: MediaQuery.of(context).size.height *0.4,
                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                               child: Column(
                                  children: [
                                    underLineTextField(
                                      hintSize: screenHeight*0.022,
                                      textSize: screenHeight*0.025,
                                      prefixSize: screenHeight*0.033,
                                      // labelText: 'Email Address',
                                      hintText: 'Email Address',
                                      prefixIcon: IconBroken.Message,
                                      type: TextInputType.emailAddress,
                                      controller: emailController,
                                        validate: (String value){
                                          if(value.isEmpty)
                                            return 'Email must not be empty' ;
                                        },
                                      // onSubmit: (){
                                      //   if(formKey.currentState!.validate()) {
                                      //    cubit.login(
                                      //        email: emailController.text,
                                      //        password: passwordController.text,
                                      //    );
                                      //   };
                                      // }
                                    ),

                                    SizedBox(height: 30,),

                                    underLineTextField(
                                      hintSize: screenHeight*0.022,
                                      textSize: screenHeight*0.025,
                                      prefixSize: screenHeight*0.033,
                                      suffixSize: screenHeight*0.03,
                                      hintText: 'Password',
                                      prefixIcon: IconBroken.Lock,
                                      suffixIcon: cubit.passIcon ,
                                      obscure: cubit.isShown,
                                      suffix: true,
                                      type: TextInputType.visiblePassword,
                                      controller: passwordController,
                                      suffixPress: (){
                                            cubit.passwordVisibility();
                                      },
                                      validate: (String value){
                                        if(value.isEmpty)
                                          return 'Password must not be empty' ;
                                      },
                                    ),

                                    SizedBox(height: screenHeight*0.075,),

                                    Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.5,
                                          child: MaterialButton(
                                            onPressed: (){
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  cubit.login(
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
                                                      'Sign in',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        // fontSize: 25,
                                                        fontSize: screenHeight*0.033,
                                                        letterSpacing: 1.5,
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
                                        if (state is LoginLoadingState )
                                          Container(
                                            padding: EdgeInsetsDirectional.only(top: 5),
                                            width: MediaQuery.of(context).size.width*0.48,
                                            child: LinearProgressIndicator(
                                              color: defaultTealAccent,
                                            ),
                                          ),
                                      ],
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
                                    //         if (formKey.currentState!
                                    //             .validate()) {
                                    //           cubit.login(
                                    //             email: emailController.text,
                                    //             password: passwordController
                                    //                 .text,
                                    //             context: context,
                                    //           );
                                    //         }
                                    //       },
                                    //       customBorder: CircleBorder(),
                                    //       highlightColor: Colors.black,
                                    //       child: CircleAvatar(
                                    //         radius: 30,
                                    //         backgroundColor: Color(0xffFF0063).withOpacity(0.95),
                                    //         // backgroundColor: Colors.teal.withOpacity(0.1),
                                    //         // child: IconButton(
                                    //         //   onPressed: () {
                                    //         //     if (formKey.currentState!.validate()) {
                                    //         //       cubit.login(
                                    //         //         email: emailController.text,
                                    //         //         password: passwordController.text,
                                    //         //          context: context ,
                                    //         //       );
                                    //         //     }
                                    //         //   },
                                    //         //   icon: Center(
                                    //         //     child: Icon(
                                    //         //       // Icons.arrow_forward_ios_outlined,
                                    //         //       IconBroken.Login,
                                    //         //       color: Colors.white ,
                                    //         //       size: 35,
                                    //         //     ),
                                    //         //   ),
                                    //         // ),
                                    //         child:  Padding(
                                    //           padding: const EdgeInsetsDirectional.only(end: 5),
                                    //           child: Icon(
                                    //             // Icons.arrow_forward_ios_outlined,
                                    //             IconBroken.Login,
                                    //             color: Colors.white ,
                                    //             size: 35,
                                    //           ),
                                    //         ),
                                    //         ),
                                    //     ),
                                    //   ],
                                    // ),

                                    SizedBox(height: screenHeight*0.015,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Do you hava an account?',
                                          style: TextStyle(
                                            color: Color(0xff4c505b),
                                            fontSize: screenHeight*0.02,
                                          ),
                                        ),
                                        SizedBox(width: 3,),
                                        TextButton(
                                            onPressed: (){
                                              navigateTo(context, RegisterScreen());
                                              cubit.isShown = true ;
                                            },
                                            style: ButtonStyle(
                                                overlayColor: MaterialStateProperty.all(defaultTealAccent.withOpacity(0.2)),
                                            ),
                                            child: Text(
                                              'Sign Up',
                                              style: TextStyle(
                                                // fontSize: 18,
                                                fontSize: screenHeight*0.025,
                                                fontWeight: FontWeight.bold,
                                                decoration: TextDecoration.underline,
                                                color: Colors.black,
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  ],
                                ),


                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          ),
        );
      },
    );
  }

   static String checkIfExist(String email , String password , List<Map> database){

     // bool exist = false ;
     // bool emailExist = false ;
     String status = 'not exist' ;

     database.forEach((element) {

      if(element['email'].toString().trim() == email.trim() ){
        status = 'email exists';

        if(element['password'].toString().trim() == password.trim()) {
          // print(element['id']);
          status = 'exist' ;
        }
      }
    });

    return status ;
   }


}



// for(int i = 0 ; i < database.length ; i++){
//   if(database[0]['email'].toString().trim() == email.trim() || database[0]['password'].toString().trim() == password.trim() ){
//     print(database[0]['email']) ;
//     print(database[0]['password']) ;
//     print(email);
//     print(password);
//     exist = true ;
//   }
// }

