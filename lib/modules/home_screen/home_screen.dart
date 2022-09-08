
import 'package:chatting/shared/components/components.dart';
import 'package:chatting/shared/remote/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login_screen/login_screen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: (){
               CasheHelper.removeDate(key: 'uId').then((value){
                 navigateAndFinish(context, LoginScreen());
               }) ;

              } ,
              child: Text(
                'Sign Out',
              ),
          ),
          if(FirebaseAuth.instance.currentUser!.emailVerified != true)
          TextButton(
              onPressed: (){
                  FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value) {
                    showToast(text: 'Check your mail', state: ToastStates.SUCCESS);
                  }).catchError((error){
                    print('Error while verifing \n' + error.toString());
                  });
              } ,
              child: Text(
                'Verify',
              ),
          ),
        ],
      ),
    );
  }
}
