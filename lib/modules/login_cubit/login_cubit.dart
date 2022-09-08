import 'package:bloc/bloc.dart';
import 'package:chatting/models/user_data_model/user_data.dart';
import 'package:chatting/modules/home_screen/home_screen.dart';
import 'package:chatting/modules/login_cubit/states.dart';
import 'package:chatting/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/remote/cache_helper.dart';
import '../../shared/styles/icon_broken.dart';

class LoginCubit extends Cubit<LoginStates>{

  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  IconData passIcon = Icons.visibility_outlined;
  bool  isShown = true ;

  void passwordVisibility()
{
  isShown =! isShown ;
  // passIcon = isShown ?  Icons.visibility_outlined : Icons.visibility_off_outlined ;
  passIcon = isShown ?  IconBroken.Show : IconBroken.Hide ;
  emit(ChangePasswordVisibility());
}

 void login({
  required String email ,
   required String password ,
   context,
}){
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      navigateTo(context, HomeScreen());
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });

 }

 void register({
   required String name ,
   required String phone ,
   required String email ,
   required String password ,
   context,
}){
    emit(RegisterLoadingState()) ;
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      createUser(
          name: name,
          phone: phone,
          email: email,
          password: password,
          uId: value.user!.uid,
        context: context ,
      );
      // emit(RegisterSuccessState());
    }).catchError((error){
      emit(RegisterErrorState(error.toString()));
    });
 }


 void createUser({
   required String name ,
   required String phone ,
   required String email ,
   required String password ,
   required String uId ,
   context ,
 }){
    // emit(CreateUserLoadingState());

    UserDataModel userDataModel = UserDataModel(
      name: name,
      phone: phone,
      email: email,
      password: password,
      uId: uId,
      image: 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465',
      cover: 'https://img.freepik.com/premium-photo/astronaut-escape-from-void_146508-24.jpg?size=626&ext=jpg',
      bio: 'Write your bio...',
    ) ;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userDataModel.toMap())
        .then((value) {
      navigateTo(context, HomeScreen());
      emit(CreateUserSuccessState(uId));
    })
        .catchError((error){
          print(error.toString());
      emit(CreateUserErrorState(error.toString()));
    });
 }

// Database ? database ;
//
// void createDatabase(){
//   openDatabase(
//     'login.db',
//     version: 1,
//     onCreate: (database ,version){
//       print('database created');
//       database.execute(
//           'CREATE TABLE login( id INTEGER PRIMARY KEY , name TEXT , phone TEXT , email TEXT , password TEXT)'
//       ).then((value) {
//           print('table created ') ;
//       }).catchError((error){
//         print('Error when created table ${error.toString()}');
//       });
//     },
//     onOpen: (database){
//       getFromDatabase(database);
//       print('database opened');
//     }
//   ).then((value) {
//     database = value ;
//     emit(LoginCreateDatabaseState());
//   });
//
// }
//
// void insertToDatabase ({
//   required String name ,
//   required String phone ,
//   required String email ,
//   required String password ,
// })async{
//
//   await database!.transaction((txn){
//     return txn.rawQuery(
//         'INSERT INTO login (name , phone , email , password) VALUES ( " $name" , " $phone" , " $email" , " $password"    )'
//     ).then((value) {
//       print( 'data inserted successfully ' );
//       print( value.toString());
//       emit(LoginInsertDatabaseState());
//       getFromDatabase(database);
//     }).catchError((error){
//       print('error when inserting database');
//       print(error.toString());
//     });
//   });
// }
//
//
//   List<Map> list = [] ;
//   void getFromDatabase(database)async
//   {
//     emit(LoginGetDatabaseLoadingState());
//      list = await database.rawQuery('SELECT * FROM login');
//     print(list) ;
//   }
//
}