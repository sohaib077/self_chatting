import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatting/main.dart';
import 'package:chatting/models/user_data_model/user_data.dart';
import 'package:chatting/modules/character_cubit/character_cubit.dart';
import 'package:chatting/modules/chatting_layout/chatting_layout.dart';
import 'package:chatting/modules/cubit/chatting_cubit.dart';
import 'package:chatting/modules/home_screen/home_screen.dart';
import 'package:chatting/modules/login_cubit/states.dart';
import 'package:chatting/shared/components/components.dart';
import 'package:chatting/shared/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/character_data_model/character_data.dart';
import '../../shared/remote/cache_helper.dart';
import '../../shared/styles/icon_broken.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


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
      // print('holaaaaaaa');
      // print(value.user!.uid);
      uId = value.user!.uid;
      CasheHelper.saveData(key: 'uId', value: uId).then((value) {
        print('hello from login cubit.');
        CharacterCubit.get(context).getCharacters();
        ChattingCubit.get(context).getUserData();
        navigateAndFinish(context, ChattingLayout());
      });

      // main();
      // navigateAndFinish(context, ChattingLayout());
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error){
      print(error);
      emit(LoginErrorState(error.toString()));
    });

 }

 void register({
   required String name ,
   required String phone ,
   required String email ,
   required String password ,
   required String nickName ,
   required String type ,
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
          nickName: nickName,
          type: type,
          uId: value.user!.uid,
        context: context ,
      );
      CasheHelper.saveData(key: 'uId', value: value.user!.uid).then((value) {
        print(uId) ;
        // CharacterCubit.get(context).getCharacters();
        // ChattingCubit.get(context).getUserData();
        // navigateAndFinish(context, ChattingLayout());
      });
      // uId = value.user!.uid;
      // emit(RegisterSuccessState());
    }).catchError((error){
      print(error);
      print('from login cubit');
      emit(RegisterErrorState(error.toString()));
    });
 }

  String avatarImage = 'assets/images/characters/char4.png';
  String charAvatarImage = 'assets/images/characters/char1.png';

    File ? testFile;
  Future<File> getImageFileFromAssets(image) async {
  final byteData = await rootBundle.load(image);

  final file = File('${(await getTemporaryDirectory()).path}/$image');
  await file.create(recursive: true);
    // profileUrl = file.path;
 await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
   testFile = file ;
  // print(file.uri);
  return file;
}


 void createUser({
   required String name ,
   required String phone ,
   required String email ,
   required String password ,
   required String nickName ,
   required String type ,
   required String uId ,
   context ,
 }){
    // emit(CreateUserLoadingState());
        getImageFileFromAssets(avatarImage).then((value) {
          firebase_storage.FirebaseStorage
            .instance
            .ref()
            .child('users/$uId/profile/${Uri
            .file(testFile!.path)
            .pathSegments
            .last}')
            .putFile(testFile!)
            .then((value) {
            value.ref.getDownloadURL().then((value) {
              print(value);

                UserDataModel userDataModel = UserDataModel(
                  name: name,
                  phone: phone,
                  email: email,
                  password: password,
                  nickName: nickName,
                  type: type,
                  uId: uId,
                  // image: 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465',
                  image: value ,
                  // cover: 'https://img.freepik.com/premium-photo/astronaut-escape-from-void_146508-24.jpg?size=626&ext=jpg',
                  cover: 'null',
                  bio: 'Write your bio...',
                ) ;

                FirebaseFirestore.instance
                    .collection('users')
                    .doc(uId)
                    .set(userDataModel.toMap())
                    .then((value) {
                      getImageFileFromAssets(charAvatarImage).then((value) {
                        firebase_storage.FirebaseStorage
                          .instance
                          .ref()
                          .child('users/$uId/characters/mainCharacter/profile/${Uri
                          .file(testFile!.path)
                          .pathSegments
                          .last}')
                          .putFile(testFile!)
                          .then((value) {
                        value.ref.getDownloadURL().then((value) {
                          print(value);

                        CharacterDataModel charModel = CharacterDataModel(
                          name: nickName,
                          date: DateTime.now().toString(),
                          type: type,
                          image: value,
                          // cover: 'https://img.freepik.com/premium-photo/astronaut-escape-from-void_146508-24.jpg?size=626&ext=jpg',
                          cover: 'null',

                          bio: 'write your bio',
                        );

                           FirebaseFirestore.instance
                              .collection('users')
                              .doc(uId)
                              .collection('characters')
                              .doc()
                              .get()
                              .then((value) {
                                print('new character id is ${value.id}');
                                FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uId)
                                  .collection('characters')
                                  .doc(value.id)
                                  .set(charModel.toMap())
                                  .then((value){
                                        CharacterCubit.get(context).getCharacters();
                                        ChattingCubit.get(context).getUserData();
                                        navigateAndFinish(context, ChattingLayout());
                                  }).catchError((error){
                                    // emit(CreateCharacterErrorState());
                                  });

                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uId)
                                    .collection('chats')
                                    .doc(value.id)
                                    .set({'date' : DateTime.now()});


                          }).catchError((error){

                            });


                        // FirebaseFirestore.instance
                        //     .collection('users')
                        //     .doc(uId)
                        //     .collection('characters')
                        //     .doc()
                        //     .set(charModel.toMap())
                        //     .then((value){
                        //   CharacterCubit.get(context).getCharacters();
                        //   ChattingCubit.get(context).getUserData();
                        //   navigateAndFinish(context, ChattingLayout());
                        //   // getCharacters();
                        //   // emit(CreateCharacterSuccessState());
                        // }).catchError((error){
                        //   // emit(CreateCharacterErrorState());
                        // });


                        emit(CreateUserSuccessState(uId));
                      })
                          .catchError((error){
                            print(error.toString());
                        emit(CreateUserErrorState(error.toString()));
                    });
                  });
               });
            });
          });
        });
      });
   }

}