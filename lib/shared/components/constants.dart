

// base url :https://newsapi.org/
// method (url) : v2/top-headlines?
//queries : country=eg&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca

//https://newsapi.org/v2/top-headlines?country=eg&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca


  // https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=a04cc589f35e4d42b94d806b76685641

// base url : https://newsapi.org/
//method (url) : v2/top-headlines?
//queries : country=us&category=business&apiKey=a04cc589f35e4d42b94d806b76685641

//https://newsapi.org/v2/everything?q=business&apiKey=a04cc589f35e4d42b94d806b76685641

import 'package:chatting/modules/login_screen/login_screen.dart';

import '../remote/cache_helper.dart';
import 'components.dart';


void printFullText(String text){
  final pattern=RegExp('.{1800}');
  pattern.allMatches(text).forEach((element) => print(element.group(0)));
}

void signOut(context){
  CasheHelper.removeDate(key: 'uId').then((value){
    // if(value)
    // uId = CasheHelper.getData('uId') ?? ' ' ;
    navigateAndFinish(context, LoginScreen());
    print('uid after removing is ${CasheHelper.getData('uId')}');
  });
}


String uId = '';
String ? profileUrl ;
String ? coverUrl ;

String ? characterProfileUrl ;
String ? characterCoverUrl ;

// String  isExist = 'false' ;
// bool autoValidate = false ;














