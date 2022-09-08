

import 'dart:ffi';

import 'package:chatting/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swipe_back_detector/swipe_back_detector.dart';



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

  Color  focusedColor = defaultTealAccent ,
  Color  cursorColor = defaultTealAccent ,
  Color  labelColor = defaultTealAccent ,

  Color  fillColor = defaultWhite ,
  bool  filled = true ,
  double textSize = 18 ,
  double hintSize = 16 ,
  double prefixSize = 28 ,
  double suffixSize = 24 ,

}) =>  TextFormField(

  style: TextStyle(
    color: textStyleColor,
    fontSize: textSize,
    letterSpacing: 0.5,
    height: 1.3,
  ),
  cursorColor: cursorColor,
  decoration: InputDecoration(
    // contentPadding: EdgeInsetsDirectional.only(start: -20 , top: 12),
    contentPadding:  EdgeInsets.fromLTRB(12.0, 12.0, -15.0, 7.0),
    fillColor: fillColor.withOpacity(0.65),
    filled: filled,
    prefixIcon: Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Icon(
          prefixIcon,
        color: prefixColor,
        size: prefixSize,
      ),
    ) ,
    suffixIcon:
    suffix != false?
    IconButton(
      icon: Icon(
          suffixIcon,
        color: suffixColor,
        size: suffixSize,
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
  // onFieldSubmitted: (value) => onSubmit!(value)  ,
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

void navigateTo(BuildContext context, Widget page , {double x = 1.0 , double y = 0.0}) {
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
  );
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
void backArrow(context) => IconButton(
  onPressed: (){
    Navigator.pop(context);
  },
  icon: Icon(
    Icons.arrow_back_ios,
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




