
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/modules/character_cubit/character_cubit.dart';
import 'package:chatting/modules/cubit/chatting_cubit.dart';
import 'package:chatting/shared/styles/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swipe_back_detector/swipe_back_detector.dart';
import 'package:url_launcher/url_launcher.dart';

import '../styles/icon_broken.dart';
import 'constants.dart';



Widget underLineTextField({
  String ? labelText ,
  String ? hintText ,
  Color  textStyleColor = Colors.black ,
  Color  hintTextColor = Colors.black ,
  Color  suffixColor = Colors.black87 ,
  Color  prefixColor = Colors.black87 ,
  bool suffix = false ,
  bool  obscure = false ,
  IconData ? prefixIcon = null ,
  IconData ? suffixIcon ,
  double ? radius ,
  TextInputType ? type ,
  TextEditingController ? controller ,
  Function ? suffixPress ,
  Function  ? validate  ,
  Function  ? onSubmit  ,
  Function  ? onChange  ,
  Function  ? onTap  ,

  int  ? maxLength  ,

  Color  focusedColor = defaultTealAccent ,
  Color  cursorColor = defaultTealAccent ,
  Color  labelColor = defaultTealAccent ,

  Color  fillColor = defaultWhite ,
  bool  filled = true ,
  // bool  autoValidate = false ,
  double textSize = 18 ,
  double hintSize = 16 ,
  double prefixSize = 28 ,
  double suffixSize = 24 ,

  bool autoValidate = false ,

}) =>  TextFormField(

autovalidateMode: autoValidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
  style: TextStyle(
    color: textStyleColor,
    fontSize: textSize,
    letterSpacing: 0.5,
    height: 1.3,
  ),
  cursorColor: cursorColor,
  maxLength: maxLength,
  decoration: InputDecoration(
    // contentPadding: EdgeInsetsDirectional.only(start: -20 , top: 12),
    contentPadding:  EdgeInsets.fromLTRB(12.0, 12.0, -15.0, 7.0),
    fillColor: fillColor.withOpacity(0.65),
    filled: filled,
    prefixIcon: Padding(
      padding: labelText != null ? const EdgeInsetsDirectional.only(top: 15.0) : const EdgeInsetsDirectional.only(top: 3.0 ,)  ,
      child: Icon(
          prefixIcon,
        color: prefixColor,
        size: prefixSize,
      ),
    ) ,
    suffixIcon:
    suffix != false?
    IconButton(
      highlightColor: Colors.transparent,
      icon: Padding(
      padding: labelText != null ? const EdgeInsetsDirectional.only(top: 15.0) : const EdgeInsetsDirectional.only(top: 3.0 ,)  ,
        child: Icon(
            suffixIcon,
          color: suffixColor,
          size: suffixSize,
        ),
      ),
      onPressed: () => suffixIcon != null ? suffixPress!() : null ,
    ) :
    Icon(suffixIcon) ,
    hintText: hintText,
    hintStyle: TextStyle(
        color: hintTextColor.withOpacity(0.6),
      height: 1.8,
      fontSize: hintSize,
    ),
    labelText: labelText,
    labelStyle: TextStyle(
      color: labelColor ,
      fontWeight: FontWeight.w500,
      fontSize: 20,
      letterSpacing: 1,
    ),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black.withOpacity(0.8),
        ),
    ),

      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: focusedColor,
          ),
    ),
  ),
  obscureText : obscure ,
  keyboardType: type ,
  controller: controller,
  validator: (value) => validate!(value),
  onFieldSubmitted: (value) => onSubmit!(value) ?? (){} ,
  // onEditingComplete: (){
  //   print('Completed');
  //   autoValidate = false;
  // },
  onChanged: (value) => onChange!(value) ,
  onTap: () => onTap!() ,
);


Widget defaultTextField({
  String ? labelText ,
  String ? hintText ,
  Color ? fillColor ,
  Color ? textStyleColor ,
  bool ? filled ,
  bool suffix = false ,
  bool  obscure = false ,
  IconData ? prefixIcon = null ,
  IconData ? suffixIcon ,
  double ? radius ,
  TextInputType ? type ,
  TextEditingController ? controller ,
  Function ? suffixPress ,
  Function  ? validate  ,
  Function  ? onSubmit  ,



}) =>  TextFormField(
  style: TextStyle(color: textStyleColor,),
  decoration: InputDecoration(
    prefixIcon: Icon(prefixIcon) ,
    suffixIcon:
        suffix != false?
    IconButton(
       icon: Icon(suffixIcon),
        onPressed: () => suffixIcon != null ? suffixPress!() : null ,
    ) :
            Icon(suffixIcon) ,
    fillColor: fillColor,
    filled: filled,
    hintText: hintText,
    labelText: labelText,
    border: OutlineInputBorder(
      borderRadius: radius != null ? BorderRadius.circular(radius) : BorderRadius.circular(0),
    ),
  ),
  obscureText : obscure ,
  keyboardType: type ,
  controller: controller,
  validator: (value) => validate!(value),
  // onFieldSubmitted: (value) => onSubmit!()  ,
);

void navigateTo(BuildContext context, Widget page , {double x = 1.0 , double y = 0.0 }) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(x, y);
        final end = Offset.zero;
        final curve = Curves.ease;
        final tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SwipeBackDetector(
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
    ),
  ).then((value) {
    // if(isScrollable)
    // scrollDown(controller);
  });
}



void navigateAndFinish(context, widget , {double x = 1.0 , double y = 0.0}) =>
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final begin = Offset(x, y);
            final end = Offset.zero;
            final curve = Curves.ease;
            final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SwipeBackDetector(
              child: SlideTransition(
                position: animation.drive(tween),
                child: child,
              ),
            );
          },
        ),      (route) {
      return false;
    }
    );
Widget backArrow(context , {Color iconColor = Colors.white , double iconSize = 30 , bool isLastMessage = false}) => IconButton(
  onPressed: (){
    // if(isLastMessage){
    //   CharacterCubit.get(context).getLastMessages().then((value){
    //     // await Future.delayed(Duration(milliseconds: 100));
    //     Navigator.pop(context);
    //
    //   });
    // }
    // else
    Navigator.pop(context);
  },
  icon: Icon(
    IconBroken.Arrow___Left_2,
    color: iconColor,
    size: iconSize,
  ),
);

void showToast({
  required String text,
  required ToastStates state,
}) =>  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates{SUCCESS , ERROR , WARNING}

Color chooseToastColor(ToastStates state)
{
  Color color ;

  switch(state){

    case ToastStates.SUCCESS : color = Colors.green ;
    break;
    case ToastStates.ERROR : color = Colors.red ;
    break;
    case ToastStates.WARNING : color = Colors.amber ;
    break;

  }
  return color;
}



void  scrollDown(controller) async{
  await Future.delayed(Duration(milliseconds: 50));
  controller.animateTo(
    controller.position.maxScrollExtent,
    duration: Duration(milliseconds: 400),
    curve: Curves.fastOutSlowIn,
  );
}

void  scrollDown1(controller) async{
  await Future.delayed(Duration(milliseconds: 100));
  controller.animateTo(
    controller.position.maxScrollExtent+300,
    duration: Duration(milliseconds: 500),
    curve: Curves.fastOutSlowIn,
  );
}

//  Uri ? _url ;
//
// Future<void> _launchUrl(url) async {
//   final _url = Uri.parse(url);
//   if (!await launchUrl(_url)) {
//     throw 'Could not launch $_url';
//   }
// }

Widget statusBar(context) =>
    Container(
                                    height: MediaQuery.of(context).viewPadding.top,
                                    color: defaultWhite.withOpacity(0.3),
                                  );




Widget cachedImage({
  required String ? image ,
  double height = 200 ,
})=>
    CachedNetworkImage(
           imageUrl:  '$image',
            // placeholder:(context, url) =>  new LinearProgressIndicator(
            //   color: defaultTealAccent,
            //   backgroundColor: Colors.transparent,
            // ),
            errorWidget: (context, url , error) => new Icon(IconBroken.Info_Square , color: Colors.red,),
          placeholderFadeInDuration: Duration(milliseconds: 100),
          fit: BoxFit.fitWidth,
          height: height ,
      // width: 200,
        );



  // final Uri _url = Uri.parse('https://www.16personalities.com/free-personality-test');
  //
  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(_url)) {
  //     throw 'Could not launch $_url';
  //   }
  // }


Widget alertDialog(
    double screenHeight,
    Function _launchUrl,
    // double screenWidth,
    )=> AlertDialog(
      title: FittedBox(
        child: Text(
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
      ),
      content: RichText(
        text: TextSpan(
        text: 'personality type refers to the psychological classification of different types of individuals.\n\nSocionics divides people into 16 different types, called sociotypes which are:',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              height: 1.25,
              color: Colors.black87,
              // fontSize: 12
              fontSize: screenHeight*0.0175
            ),
          children:  [
            TextSpan(
              text: '\n\n- ESTJ       - ENTJ       - ESFJ       - ENFJ      \n- ISTJ        - ISFJ        - INTJ        - INFJ      \n- ESTP      - ESFP       - ENTP      - ENFP      \n- ISTP       - ISFP        - INTP       - INFP      \n',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                height: 1.5,
                color: Colors.black87,
                // fontSize: 14,
                fontSize: screenHeight*0.02
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
