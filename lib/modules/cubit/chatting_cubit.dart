
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatting/models/user_data_model/user_data.dart';
import 'package:chatting/modules/character_cubit/character_cubit.dart';
import 'package:chatting/shared/components/components.dart';
import 'package:chatting/shared/components/constants.dart';
import 'package:chatting/shared/remote/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../shared/styles/colors.dart';
import '../chat_screen/chat_screen.dart';
import '../login_screen/login_screen.dart';
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
  int controller = 0 ;

  void changeBottomNav(index){
    currentIndex = index ;
    emit(ChattingChangeBottomNavState());
  }
  
  UserDataModel ? userData ;
  
  void getUserData (){
    uId = CasheHelper.getData('uId');
    // print('uId before getting user data is \n $uId');
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

  Future getProfileImage(context) async {
    final PickedFile ? pickedFile = await pickerProfile.getImage(
        source: ImageSource.gallery);
    if (PickedFile != null) {
      // profileImage = File(PickedFile.path);
       cropImage(pickedFile!  , context , isCircle: true , x : MediaQuery.of(context).size.height*0.09 , y : MediaQuery.of(context).size.height*0.09) ;
      emit(ProfileImagePickedSuccessState());
    } else {
      print('No Profile Image Selected');
    }
  }


  File ? coverImage;

  Future getCoverImage(context) async {
    final PickedFile ? pickedFile = await pickerProfile.getImage(
        source: ImageSource.gallery);
    if (PickedFile != null) {
      // coverImage = File(PickedFile.path);
      cropImage(pickedFile! , context, isCoverImage: true , x : MediaQuery.of(context).size.width, y : MediaQuery.of(context).size.height*0.3) ;
      emit(CoverImagePickedSuccessState());
    } else {
      print('No Cover Image Selected');
    }
  }


  cropImage(
      PickedFile picked ,
      context,
      {
        bool ? isCircle = false,
        double  x = 100 ,
        double  y = 100 ,
        bool ? isCoverImage = false ,

      }) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      uiSettings: [
        AndroidUiSettings(
        statusBarColor: defaultTeal,
        toolbarColor: defaultTeal,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: defaultWhite,
        backgroundColor: defaultTeal ,
        showCropGrid: false ,
        cropFrameStrokeWidth: 0,
        cropFrameColor: Colors.transparent,
        // dimmedLayerColor: defaultTealAccent
      ),
      ],
      sourcePath: picked.path,
      cropStyle: isCircle == true ? CropStyle.circle : CropStyle.rectangle ,
      aspectRatio: CropAspectRatio(ratioX: x, ratioY: y),
      // maxWidth: 800,
    ).then((value) {
      if (value != null) {
        isCoverImage == false ?
        profileImage = File(value.path) :
            coverImage =  File(value.path) ;
        // return File(cropped.path) ;
      }
      else{
        if(! isCoverImage!)
          getProfileImage(context) ;
        else
          getCoverImage(context) ;
      }
      emit(ProfileImageCroppedSuccessState());
    }).catchError((error){
      print('Error while cropping profile image ${error.toString()}');
    });

    // return File(cropped!.path) ;
  }



  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
    String ? type ,
  }) {
    emit(UpdateLoadingState());

    // if(profileUrl != null){
      deleteImages('profile');
    // }
    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('users/$uId/profile/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {

        CasheHelper.saveData(key: 'profileUrl', value: value) ;

        profileUrl = value;
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
          type: type ,
        );
        // emit(UpdateProfileSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(UpdateProfileErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(UpdateProfileErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
    String ? type ,
  }) {
    emit(UpdateLoadingState());
    // if(coverUrl != null){
      deleteImages('cover');
    // }
    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('users/$uId/cover/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {

        CasheHelper.saveData(key: 'coverUrl', value: value) ;

        coverUrl = value;
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
          type: type,
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

    bool isAvatarImage = false;
  int avatarIndex = 0;
  String avatarImage = 'assets/images/characters/char1.png';

  void changeAvatarIndex({
  required int index
}){
    avatarIndex = index ;
    avatarImage = 'assets/images/characters/char${index+1}.png' ;

    emit(ChangeAvatarIndexSuccesState());
  }

    File ? testFile;
  Future<File> getImageFileFromAssets() async {
  final byteData = await rootBundle.load(avatarImage);

  final file = File('${(await getTemporaryDirectory()).path}/$avatarImage');
  await file.create(recursive: true);
    // profileUrl = file.path;
 await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
   testFile = file ;
  // print(file.uri);
  return file;
}


  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String ? cover ,
    String ? image ,
    String ? type ,
  }){
    emit(UpdateLoadingState());
      if(isAvatarImage){
      deleteImages('profile');
        getImageFileFromAssets().then((value) {
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
              UserDataModel model = UserDataModel(
                name: name ,
                phone: phone,
                email: userData!.email,
                uId: userData!.uId,
                cover: cover ?? userData!.cover ,
                image: value,
                type: type ?? '',
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
              });
            });
          });
        }

    else{
    UserDataModel model = UserDataModel(
    name: name ,
    phone: phone,
    email: userData!.email,
    uId: userData!.uId,
    cover: cover ?? userData!.cover ,
    image: image ?? userData!.image,
    type: type ?? '',
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
  }

  void updateAllOfThem({
    required String name,
    required String phone,
    required String bio,
    String ? type ,

  }){

    emit(UpdateLoadingState());
    // if(profileUrl != null){
      deleteImages('profile');
    // }
    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('users/$uId/profile/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {

        CasheHelper.saveData(key: 'profileUrl', value: value) ;

        profileUrl = value;
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
          type: type,
        );

        uploadCoverImage(
          name: name,
          phone: phone,
          bio: bio,
          type: type,
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

  void deleteImages(image){

    if(  image == 'profile'&& userData!.image!.contains('firebasestorage'))
    {
      // image == 'profile' ?
      firebase_storage.FirebaseStorage
          .instance
          .refFromURL(userData!.image!)
          .delete()
          .then((value) {
        // print(value.toString());
        // emit(DeleteSuccessState());
        print("Deleted Successfully");
      }).catchError((error){
        print(error.toString());
        // emit(DeleteErrorState());
      });
    }
    else if(  image == 'cover'&& userData!.cover!.contains('firebasestorage')) {
      firebase_storage.FirebaseStorage
          .instance
          .refFromURL(userData!.cover!)
          .delete()
          .then((value) {
        // print(value.toString());
        // emit(DeleteSuccessState());
        print("Deleted Successfully");
      }).catchError((error) {
        print(error.toString());
        // emit(DeleteErrorState());
      });
    }

    else{
      print('noooooooooot found');
    }
  }


}



  // void logout (context){
  //   navigateAndFinish(context, LoginScreen);
  // }






