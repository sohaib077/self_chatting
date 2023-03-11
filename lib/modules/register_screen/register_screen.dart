import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
  var nickNameController = TextEditingController() ;
  var phoneController = TextEditingController() ;
  var emailController = TextEditingController() ;
  var passwordController = TextEditingController() ;
  var typeController = TextEditingController() ;


  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {


    var screenHeight =  MediaQuery.of(context).size.height ;
    var screenWidth =  MediaQuery.of(context).size.width ;

    return BlocConsumer<LoginCubit , LoginStates>(
      listener: (context, state){
        if(state is RegisterErrorState){

          if(state.error.contains('The email address is already in use by another account.'))
           showToast(text: 'The email address is already in use by another account.', state: ToastStates.ERROR);

         else if(state.error.contains('Password should be at least 6 characters'))
          showToast(text: 'Password should be at least 6 characters.', state: ToastStates.ERROR);

         else if(state.error.contains('The email address is badly formatted'))
          showToast(text: 'The email address is badly formatted.', state: ToastStates.ERROR);

         else if(state.error.contains('A network error'))
            showToast(text: 'Please, check your internet connection.', state: ToastStates.ERROR);

          else
            showToast(text: state.error.substring(state.error.indexOf(']')+1 ), state: ToastStates.ERROR);


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
              fit: BoxFit.fitWidth,
            ),
          ),
          child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },

              child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    IconBroken.Arrow___Left_2,
                    size: screenHeight*0.04,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  } ,
                ),
              ),
              body:
              Form(
                key: formKey,
                child: Container(
                  child: Stack(
                    children: [
                       SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          padding: EdgeInsetsDirectional.only(
                            top: screenHeight*0.22,
                            bottom: screenHeight*0.1,
                            start: screenWidth*0.1,
                            end: screenWidth*0.1,
                            // start: 40,
                            // end: 40,
                          ),
                          child: Column(
                            children: [
                              underLineTextField(
                                onTap: (){},
                                  onChange: (value){},
                                  onSubmit: (value){},
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
                                  if(value.trim().isEmpty)
                                    return 'Please enter your name' ;
                                }
                              ),
                              SizedBox(height: screenHeight*0.02,),

                              underLineTextField(
                                onTap: (){},
                                  onChange: (value){},
                                  onSubmit: (value){},
                                hintSize: screenHeight*0.022,
                                textSize: screenHeight*0.025,
                                prefixSize: screenHeight*0.033,

                                hintText: 'Nickname',
                                prefixIcon: IconBroken.User,
                                type: TextInputType.name,
                                // filled: true,
                                // fillColor: Colors.grey.shade100,
                                controller: nickNameController,
                                validate: (String value){
                                  if(value.trim().isEmpty)
                                    return 'Please enter your Nickname' ;
                                }
                              ),
                              SizedBox(height: screenHeight*0.02,),

                              underLineTextField(
                                onTap: (){},
                                  onChange: (value){},
                                  onSubmit: (value){},
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
                                    if(value.trim().isEmpty)
                                      return 'Please enter your phone' ;
                                  }
                              ),
                              SizedBox(height: screenHeight*0.02,),

                              underLineTextField(
                                onTap: (){},
                                  onChange: (value){},
                                  onSubmit: (value){},
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
                                    if(value.trim().isEmpty)
                                      return 'Please enter an available email' ;
                                  }

                              ),

                              SizedBox(height: screenHeight*0.02,),

                              underLineTextField(
                                onTap: (){},
                                onChange: (value){},
                                onSubmit: (value){},
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
                                    if(value.trim().isEmpty)
                                      return 'Please enter an available password' ;
                                  },

                              ),

                              SizedBox(height: screenHeight*0.02,),

                              underLineTextField(
                                onTap: (){},
                                onChange: (value){},
                                onSubmit: (value){},
                                validate: (String value){},

                                hintSize: screenHeight*0.022,
                                textSize: screenHeight*0.025,
                                prefixSize: screenHeight*0.038,

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
                                        return alertDialog(screenHeight, _launchUrl);
                                      }
                                  );
                                },
                              ),


                              SizedBox(height: screenHeight*0.035,),

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
                                        nickName: nickNameController.text.trim(),
                                        type: typeController.text.trim(),
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
                              if (state is  RegisterLoadingState )
                                  Container(
                                    padding: EdgeInsetsDirectional.only(top: screenHeight*0.008),
                                    width: MediaQuery.of(context).size.width*0.48,
                                    child: LinearProgressIndicator(
                                      color: defaultTealAccent,
                                      backgroundColor: Colors.transparent,
                                      minHeight: screenHeight*0.004,
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                      ClipPath(
                        clipper: CustomClipPath(),
                        // child: Container(
                        //   height: screenHeight*0.3,
                        //   color: Colors.redAccent,
                        // ),
                      ),

                    ],
                  ),

                ),
              ),
            ),
          ),
        );
      },
    );
  }

  final Uri _url = Uri.parse('https://www.16personalities.com/free-personality-test');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

}

class CustomClipPath extends CustomClipper<Path> {
  // var radius=5.0;
  @override
  Path getClip(Size size) {
    double w = size.width ;
    double h = size.height ;
    Path path0 = Path();

    // path0.moveTo(w , 0);
    // path0.lineTo(w , h*0.8);
    // path0.quadraticBezierTo(w*0.75 , h*0.3 , w*0.5 , h*0.8);
    // path0.quadraticBezierTo(w*0.2 , h*1.25 , 0, h*0.8);
    // path0.lineTo(0 , 0);

    path0.moveTo(0  , h*0.7);
    path0.quadraticBezierTo(w*0.0843750  , h*0.9282143,w*0.2491667  , h*0.9271429);
    path0.quadraticBezierTo(w*0.4161667  , h*0.9282143,w*0.5005000  , h*0.7);
    path0.quadraticBezierTo(w*0.5826667  , h*0.5014286,w*0.7505000  , h*0.5005714);
    path0.quadraticBezierTo(w*0.9160000  , h*0.5014286,w*0.9991667  , h*0.7);
    path0.lineTo(w*0.9991667  , h*0.0014286);
    path0.lineTo(w*0.0025000  , h*0.0014286);
    path0.lineTo(0  , h*0.7142857);
    path0.close();


    return path0;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// class RPSCustomPainter extends CustomPainter{
//
//   @override
//   void paint(Canvas canvas, Size size) {
//
//
//
//   Paint paint0 = Paint()
//       ..color = const Color.fromARGB(255, 33, 150, 243)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 6.99;
//
//
//     Path path0 = Path();
//     path0.moveTo(0,size.height*0.7142857);
//     path0.quadraticBezierTo(size.width*0.0843750,size.height*0.9282143,size.width*0.2491667,size.height*0.9271429);
//     path0.quadraticBezierTo(size.width*0.4161667,size.height*0.9282143,size.width*0.5005000,size.height*0.7142857);
//     path0.quadraticBezierTo(size.width*0.5826667,size.height*0.5014286,size.width*0.7505000,size.height*0.5005714);
//     path0.quadraticBezierTo(size.width*0.9160000,size.height*0.5014286,size.width*0.9991667,size.height*0.7142857);
//     path0.lineTo(size.width*0.9991667,size.height*0.0014286);
//     path0.lineTo(size.width*0.0025000,size.height*0.0014286);
//     path0.lineTo(0,size.height*0.7142857);
//     path0.close();
//
//     canvas.drawPath(path0, paint0);
//
//
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
//
// }

