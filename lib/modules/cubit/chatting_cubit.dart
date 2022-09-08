
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatting/models/user_data_model/user_data.dart';
import 'package:chatting/shared/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../chat_screen/chat_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../users_screen/users_screen.dart';
import 'chatting_states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class ChattingCubit extends Cubit<ChattingStates>{

  ChattingCubit() : super(ChattingInitialState()) ;

  static ChattingCubit get(context) => BlocProvider.of(context) ;

  List <Widget> screens =[
    UsersScreen(),
    ChatScreen(),
    ProfileScreen(),
  ] ;

  int currentIndex = 1 ;

  void changeBottomNav(index){
    currentIndex = index ;
    emit(ChattingChangeBottomNavState());
  }
  
  UserDataModel ? userData ;
  
  void getUserData (){
    emit(GetUserDataLoadingState());
    
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value){
          userData = UserDataModel.fromJson(value.data()!) ;
          emit(GetUserDataSuccessState());
    })
        .catchError((error){
      emit(GetUserDataErrorState());
    });
  }

  File ? profileImage;
  var pickerProfile = ImagePicker();

  Future getProfileImage() async {
    final PickedFile = await pickerProfile.getImage(
        source: ImageSource.gallery);
    if (PickedFile != null) {
      profileImage = File(PickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      print('No Profile Image Selected');
    }
  }

  File ? coverImage;

  Future getCoverImage() async {
    final PickedFile = await pickerProfile.getImage(
        source: ImageSource.gallery);
    if (PickedFile != null) {
      coverImage = File(PickedFile.path);
      emit(CoverImagePickedSuccessState());
    } else {
      print('No Cover Image Selected');
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UpdateLoadingState());
    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // profileUrl = value;
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        print(error.toString());
        // emit(SocialUpdateProfileImageErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      // emit(SocialUpdateProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(UpdateLoadingState());
    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // coverUrl = value;
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
        emit(UpdateCoverSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(UpdateCoverErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(UpdateCoverErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String ? cover ,
    String ? image ,
  }){
    emit(UpdateLoadingState());
    UserDataModel model = UserDataModel(
      name: name ,
      phone: phone,
      email: userData!.email,
      uId: userData!.uId,
      cover: cover ?? userData!.cover ,
      image: image ?? userData!.image,
      bio: bio,
    );


    FirebaseFirestore
        .instance
        .collection('users')
        .doc(model.uId!)
        .update(model.toMap())
        .then((value){
      getUserData();
      emit(UpdateSuccessState());
    })
        .catchError((error){
      emit(UpdateErrorState());
    });
  }

  void updateAllOfThem({
    required String name,
    required String phone,
    required String bio,

  }){

    emit(UpdateAllOfThemLoadingState());
    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // profileUrl = value;
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );

        uploadCoverImage(
          name: name,
          phone: phone,
          bio: bio,
        );
        emit(UpdateAllOfThemSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(UpdateAllOfThemErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(UpdateAllOfThemErrorState());
    });
  }

  }





