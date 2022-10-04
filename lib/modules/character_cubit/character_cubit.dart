import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatting/models/character_data_model/character_data.dart';
import 'package:chatting/modules/character_cubit/character_states.dart';
import 'package:chatting/shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/message_model/message_model.dart';
import '../../shared/components/constants.dart';
import '../../shared/remote/cache_helper.dart';

import '../../shared/styles/colors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class CharacterCubit extends Cubit<CharacterStates> {

  CharacterCubit() : super(CharacterInitialState()) ;

  static CharacterCubit get(context) => BlocProvider.of(context);

  File ? characterProfileImage;
  var pickerProfile = ImagePicker();

  Future getProfileImage(context) async {
    final PickedFile ? pickedFile = await pickerProfile.getImage(
        source: ImageSource.gallery);
    if (PickedFile != null) {
      // characterProfileImage = File(PickedFile.path);
      cropImage(pickedFile!  , context , isCircle: true , x : MediaQuery.of(context).size.height*0.09 , y : MediaQuery.of(context).size.height*0.09) ;
      emit(CharacterProfileImagePickedSuccessState());
    } else {
      print('No Profile Image Selected');
    }
  }


  File ? characterCoverImage;

  Future getCoverImage(context) async {
    final PickedFile ? pickedFile = await pickerProfile.getImage(
        source: ImageSource.gallery);
    if (PickedFile != null) {
      // characterCoverImage = File(PickedFile.path);
      cropImage(pickedFile! , context, isCoverImage: true , x : MediaQuery.of(context).size.width, y : MediaQuery.of(context).size.height*0.3) ;
      emit(CharacterCoverImagePickedSuccessState());
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
        bool ? isMessageImage = false ,

      }) async {
    CroppedFile? cropped = await ImageCropper().cropImage(
      uiSettings: [
        AndroidUiSettings(
          statusBarColor: defaultTeal,
          toolbarColor: defaultTeal,
          toolbarTitle: "Crop Image",
          toolbarWidgetColor: Colors.white,
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

        if(isCoverImage == true )
          characterCoverImage =  File(value.path) ;
        else
          characterProfileImage = File(value.path) ;

        if(isMessageImage == true )
          messageImage =  File(value.path) ;


      // return File(cropped.path) ;
      }
      else{
        if(! isCoverImage!)
          getProfileImage(context) ;
        else
          getCoverImage(context) ;
      }
      emit(CharacterCroppedImagePickedSuccessState());
    }).catchError((error){
      print('Error while cropping profile image ${error.toString()}');
    });

    // return File(cropped!.path) ;
  }


  Future test ()async{

    getImageFileFromAssets().then((value) {
          firebase_storage.FirebaseStorage
          .instance
          .ref()
          .child('users/test/${Uri
          .file(testFile!.path)
          .pathSegments
          .last}')
          .putFile(testFile!)
          .then((value) {
            value.ref.getDownloadURL().then((value) {
              // CasheHelper.saveData(key: 'characterProfileUrl', value: value) ;

              avatarUrl = value;
              print(value);
            });
          });
          });
  }

  File ? testFile;
  Future<File> getImageFileFromAssets() async {
  final byteData = await rootBundle.load(avatarImage);

  final file = File('${(await getTemporaryDirectory()).path}/$avatarImage');
  await file.create(recursive: true);
    // profileUrl = file.path;
 await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
   testFile = file ;
  print(file.uri);
  return file;
}

  createCharacter({

    required String name ,
    required String bio ,
    required String date ,
    required String type ,
     String ? profileImage ,
    String ? coverImage ,
    context ,


  }){
    emit(CreateCharacterLoadingState());
    if(characterProfileImage != null){
              CharacterDataModel charModel = CharacterDataModel(
                name: name,
                date: DateTime.now().toString(),
                type: type,
                image: profileImage != null ?  profileImage :
                'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465',
                //                             'assets/images/char1.png',
                cover: coverImage != null ?  coverImage :
                // 'https://img.freepik.com/premium-photo/astronaut-escape-from-void_146508-24.jpg?size=626&ext=jpg',
                'null',

                bio: bio,
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

                  getCharacters();
                    emit(CreateCharacterSuccessState());
              }).catchError((error){
                emit(CreateCharacterErrorState());
              });

                FirebaseFirestore.instance
                    .collection('users')
                    .doc(uId)
                    .collection('chats')
                    .doc(value.id)
                    .set({'date' : DateTime.now()});


          }).catchError((error){

            });

    }
    else {
      getImageFileFromAssets().then((value) {
        firebase_storage.FirebaseStorage
            .instance
            .ref()
            .child('users/test/${Uri
            .file(testFile!.path)
            .pathSegments
            .last}')
            .putFile(testFile!)
            .then((value) {
          value.ref.getDownloadURL().then((value) {
            CharacterDataModel charModel = CharacterDataModel(
              name: name,
              date: DateTime.now().toString(),
              type: type,
              // image: profileImage != null ?  profileImage :
              // 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465',
              // //                             'assets/images/char1.png',
              image: value,
              cover: coverImage != null ? coverImage :
              // 'https://img.freepik.com/premium-photo/astronaut-escape-from-void_146508-24.jpg?size=626&ext=jpg',
                'null' ,
              bio: bio,
            );

            // FirebaseFirestore.instance
            //     .collection('users')
            //     .doc(uId)
            //     .collection('characters')
            //     .doc()
            //     .set(charModel.toMap())
            //     .then((value){
            //
            //     getCharacters();
            //       emit(CreateCharacterSuccessState());
            // }).catchError((error){
            //   emit(CreateCharacterErrorState());
            // });

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
                  .then((value) {
                getCharacters();
                emit(CreateCharacterSuccessState());
              }).catchError((error) {
                emit(CreateCharacterErrorState());
              });

              FirebaseFirestore.instance
                  .collection('users')
                  .doc(uId)
                  .collection('chats')
                  .doc(value.id)
                  .set({'date': DateTime.now()});
            }).catchError((error) {

            });
          });
        });
      });
    }
  }

  // String profileUrl = 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465' ;
  String profileUrl = 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465' ;
  String coverUrl = 'https://img.freepik.com/premium-photo/astronaut-escape-from-void_146508-24.jpg?size=626&ext=jpg' ;

  String ? avatarUrl ;



  void uploadProfileImage({
    required String name ,
    required String bio ,
    // required String charId ,
    required String type ,
    context,
}) {
    emit(CreateCharacterLoadingState());

    // if(profileUrl != null){
    //   deleteImages(profileUrl);
    // }
    if(characterProfileImage != null) {
      firebase_storage.FirebaseStorage
          .instance
          .ref()
          .child('users/characters/$name/${Uri
          .file(characterProfileImage!.path)
          .pathSegments
          .last}')
          .putFile(characterProfileImage!)
          .then((value) {
        value.ref.getDownloadURL().then((value) {
          // CasheHelper.saveData(key: 'characterProfileUrl', value: value) ;

          profileUrl = value;
          print(value);

          if (characterCoverImage != null) {
            uploadCoverImage(
              name: name,
              bio: bio,
              type: type,
              date: DateTime.now().toString(),
              profileImage: profileUrl,
              context: context,
            );
          }

          else {
            createCharacter(
              name: name,
              bio: bio,
              profileImage: profileUrl,
              date: DateTime.now().toString(),
              type: type ,
              context: context,
              // coverImage: coverUrl,
            );
          }
          // emit(UpdateProfileSuccessState());
        }).catchError((error) {
          print(error.toString());
          // emit(UpdateProfileErrorState());
        });
      }).catchError((error) {
        print(error.toString());
        // emit(UpdateProfileErrorState());
      });
    }
    else{
      print('hello from profile uploading error');

      if (characterCoverImage != null) {
        uploadCoverImage(
          name: name,
          bio: bio,
          type: type,
          date: DateTime.now().toString(),
          profileImage: profileUrl,
          context: context,
        );
      }
      else {
        createCharacter(
          name: name,
          bio: bio,
          date: DateTime.now().toString(),
          type: type,
          profileImage: profileUrl,
          context: context,
          // coverImage: coverUrl,
        );
      }
    }
  }

  int controller = 0 ;
  void uploadCoverImage({
    required String name ,
    required String bio ,
    required String type ,
    required String profileImage ,
    required String date,
    context,
  })  {
    emit(CreateCharacterLoadingState());

    // if(profileUrl != null){
    //   deleteImages(profileUrl);
    // }

    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('users/characters/$name/${Uri
        .file(characterCoverImage!.path)
        .pathSegments
        .last}')
        .putFile(characterCoverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // CasheHelper.saveData(key: 'characterProfileUrl', value: value) ;
        coverUrl = value;
        print(value);

        print('Before creating : \n cover = $value \n profile =$profileUrl');
        createCharacter(
            name: name,
            bio: bio,
            type: type,
          coverImage: value,
          profileImage: profileUrl,
          date: DateTime.now().toString(),
          context: context,
        );
        // emit(UpdateProfileSuccessState());
      }).catchError((error) {
        print(error.toString());
        // emit(UpdateProfileErrorState());
      });
    }).catchError((error) {
      print('hello from uploading cover error');
      createCharacter(
        name: name,
        bio: bio,
        type: type,
        date: DateTime.now().toString(),
        profileImage: profileUrl,
        context: context,
      );
      print(error.toString());
      // emit(UpdateProfileErrorState());
    });
  }


  List <CharacterDataModel>  charModel =[];
  List <String>  charId =[];
  int ? charSize ;

  void getCharacters(){
    charId =[];
    charModel =[];
    uId = CasheHelper.getData('uId');
    // print('uid before getting characters $uId');
    emit(GetCharactersLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('characters').orderBy('date')
        .get()
        .then((value) {
          charSize = value.size ;
          for(int i = 0 ; i < charSize!  ; i++){

            charModel.add(CharacterDataModel());
            charModel[i] =  CharacterDataModel.fromJson(value.docs.elementAt(i).data());
            charId.add(value.docs.elementAt(i).id);
            print(charId[i]);
            // print(value.docs.elementAt(i).id);
            print(charModel[i].name);
            // if(i==charSize!-1)
            //   getLastMessages();

          }
          emit(GetCharactersSuccessState());
    }).catchError((error){
      print('Error while getting characters ${error.toString()}');
      emit(GetCharactersErrorState());
    });


  }

  // String charId = '';
  void deleteCharacter(index , context){
    emit(DeletingLoadingState());
    if(charModel.length > 1) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('characters').orderBy('date')
          .get()
          .then((value) {
        // charId = value.docs.elementAt(index).id;
        deleteConversation(context, receiverId: value.docs.elementAt(index).id);
            FirebaseFirestore.instance
                .collection('users')
                .doc(uId)
                .collection('chats')
                .doc(value.docs.elementAt(index).id)
                .delete();

        print(value.docs.elementAt(index).id);

        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .collection('characters')
            .doc(value.docs.elementAt(index).id)
            .delete().then((value) {
          // Navigator.pop(context);
          getCharacters();
          deleteImages('profile', index);
          deleteImages('cover', index);
          emit(DeleteCharactersSuccessState());
        }).catchError((error) {
          print('Error while deleting characters ${error.toString()}');
          emit(DeleteCharactersErrorState());
        });
      }).catchError((error) {
        print('Error while deleting characters ${error.toString()}');
        emit(DeleteCharactersErrorState());
      });
    }
    else{
      showToast(
          text: 'You can\'t have less than one Character ' ,
          state: ToastStates.ERROR,
      );
      Navigator.pop(context);
    }
  }

  String ? isExist ;

  String? checkIfExist(String name)   {

      // emit(CheckLoadingState());

     FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('characters')
          .get()
          .then((value)  {
        // print(value.docs.elementAt(0).data().values.contains(name.trim()));
        for(int i = 0 ; i < charSize!  ; i++){
          if(value.docs.elementAt(i).data().values.contains(name.trim())) {
            // print('true');
            // return true ;
            isExist = 'true';
            print(isExist);
            // emit(CheckSuccessState());
            return  isExist ;
          }
          isExist = "false";
          // return isExist;
        }
        // emit(CheckErrorState());
        // isExist = false ;
        // print(isExist.toString());
      }).catchError((error){});

    return  isExist ;

    }

  void sendMessage({
    required String ? text ,
    required String ? receiverId ,
    required String ? dateTime ,
    String ? messageImage ,
    String  ? senderId ,

  }){

    // if(senderId == null)
    //   senderId = uId;

    MessageModel model = MessageModel(
      text: text,
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: senderId == null ? uId : senderId,
      messageImage: messageImage,
    );

    if(isMe) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .add(model.toMap()).then((value) {

        emit(SendMessageSuccessState());
      }).catchError((error) {
        emit(SendMessageErrorState());
      });


    }
    else{
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats')
          .doc(senderId)
          .collection('messages')
          .add(model.toMap()).then((value) {


        emit(SendCharMessageSuccessState());
      }).catchError((error) {
        emit(SendCharMessageErrorState());
      });



    }

  }

  List<MessageModel> messages =[] ;
  void getMessages({
    required String ? receiverId ,
  }){
    emit(GetMessagesLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      // if(messages.length != 0)
      messages = [] ;
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessagesSuccessState());
    });

  }


  List <String> chatsNumber = [];
  Future numberOfChats()async{
    // lastMessages = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .get()
        .then((value) {
      chatsNumber = [];

      // value.docs.forEach((element) {
      //   chatsNumber.add(element.id);
      //   // print(element.id);
      // });

      for(var element in value.docs){
          chatsNumber.add(element.id);
          // print(element.id);
      }
      print('number of chats is ${chatsNumber.length}');
      if(charId.length > 1)
        getMostChatting();
        // getLastMessages();
      emit(GetNumberOfChatsSuccessState());
        });
  }

  List<MessageModel> lastMessages =List.filled(10, MessageModel()) ;
  // List<MessageModel> lastMessages =[MessageModel() , MessageModel()] ;
  // int i = 0 ;
  Future getLastMessages() async {
    // chatsLength();
    // numberOfChats();
    // for(int i = 0 ; i < lastMessages.length ; i ++){
    //   lastMessages[i] = MessageModel();
    // }

    // print('hello from last messages${chatsNumber.length}');
    // i=0 ;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats').orderBy('date')
        .get()
        .then((value) {
      // for(var element in value.docs){
      for(int i=0 ; i < value.size ; i++){
        print('from last messages ${value.docs.elementAt(i).id}');
        FirebaseFirestore.instance
            .collection('users')
            .doc(uId)
            .collection('chats')
            .doc(value.docs.elementAt(i).id)
            .collection('messages')
            .orderBy('dateTime')
            .snapshots()
            .listen((event) {
              // print(i);
              // if(messages.length != 0)
              // lastMessages.add(MessageModel.fromJson(event.docs.last.data()));
              event.docs.length > 0 ?
              lastMessages[i] = MessageModel.fromJson(event.docs.last.data()) :
                  lastMessages[i].text = null ;
              print('${lastMessages[i].text}');
              // i++ ;
          // print(element.id) ;
        });
      }
      emit(GetLastMessagesSuccessState());
  });
        }

  CharacterDataModel mostChatting = CharacterDataModel();
  int max = 0 ;
  Future getMostChatting()async{
    // numberOfChats();
    // max = 0 ;
    print('from most chatting ${chatsNumber.length}');
    for (int i = 0; i < chatsNumber.length; i++ ) {
      // print('from most chatting ${chatsNumber[i]}');
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats')
          .doc(chatsNumber[i])
          .collection('messages')
          .orderBy('dateTime')
          // .snapshots()
          // .listen((event) async{
          .snapshots()
          .listen((event) async{
            if(max < event.docs.length){
              max = event.docs.length;
              // mostChatting = CharacterDataModel();
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(uId)
                  .collection('characters')
                  .doc(chatsNumber[i])
                  .get()
                  .then((value){
                mostChatting = CharacterDataModel.fromJson(value.data()!);
                max = event.docs.length;
                print('max is $max');
                print(mostChatting.name);
              });

            }
        // lastMessages.add(MessageModel.fromJson(event.docs.last.data()));
        // print(event.docs.length);
      });
    }
    emit(GetMostChattingSuccessState());

  }

  void deleteMessages(context ,{
    required String ? receiverId ,
    required String ? date ,
  }){
    max = 0;
    emit(DeletingLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        // .orderBy('dateTime')
        .where( 'dateTime' , isEqualTo: date)
        .get()
        .then((value) {

      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .doc(value.docs.first.id)
          .delete()
          .then((value){
            print('Message deleted successfully');
              // max = 0;
              Navigator.pop(context);
              getMostChatting();
              // getMessages(receiverId: receiverId);
              emit(DeleteMessageSuccessState());

            // getMessages(receiverId: receiverId);
            // emit(DeleteCharactersSuccessState());
      });

        });


  }

  void deleteConversation(context ,{
    required String ? receiverId ,
  }){
    emit(DeletingLoadingState());
    print(receiverId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .get()
        .then((value) {
            value.docs.forEach((element) {
              element.reference.delete();
            });

              max = 0;
              numberOfChats();
              print('Conversation deleted successfully');
              Navigator.pop(context);
              emit(DeleteConversationSuccessState());
    });


  }

  File ? messageImage;

  Future getMessageImage() async {
    final PickedFile = await pickerProfile.getImage(
        source: ImageSource.gallery);
    if (PickedFile != null) {
      messageImage = File(PickedFile.path);
      emit(MessageImagePickedSuccessState());
    } else {
      print('No Image Selected');
      emit(MessageImagePickedErrorState());
    }
  }

bool uploadingMessageImage = false ;
  void uploadMessageImage({
    // required String ? messageImage ,
    required String ? receiverId ,
    required String ? dateTime ,
    required String ? text ,
     String ? senderId ,
  }) {
    uploadingMessageImage = true ;
    emit(UploadMessageImageLoadingState());

    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('chatImages/$uId/${senderId!.substring(senderId.length-4)}to${receiverId!.substring(receiverId.length-4)}/${Uri.file(messageImage!.path)
        .pathSegments
        .last}')
        .putFile(messageImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // messageImageUrl = value;
        print(value);
        sendMessage(
          text: text,
          receiverId: receiverId,
          dateTime: dateTime,
          messageImage: value,
          senderId: senderId,
        );
        uploadingMessageImage= false ;
        emit(UploadMessageImageSuccessState());

      }).catchError((error) {
        print(error.toString());
        uploadingMessageImage= false ;
        emit(UploadMessageImageErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      uploadingMessageImage= false ;
      emit(UploadMessageImageErrorState());
    });
  }

  void removeMessageImage(){
    messageImage = null ;
    emit(RemoveMessageImageState());
  }

bool isMe = true ;
  void switchSender(){
    isMe = ! isMe ;
    emit(SwitchSenderState());

  }

Color color = defaultTealAccent ;
  void switchColor(){
    isMe ? color = defaultTealAccent : color = defaultGrey ;
    emit(SwitchColorState());
  }

  String ? characterProfileUrl ;
  String ? characterCoverUrl ;

  void updateProfileImage({
    required String name,
    required String type,
    required String bio,
    required int index,
  }) {
    emit(UpdateCharacterLoadingState());

    deleteImages('profile' , index);

    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('users/$uId/characters/${charId[index]}/profile/${Uri
        .file(characterProfileImage!.path)
        .pathSegments
        .last}')
        .putFile(characterProfileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {

        characterProfileUrl = value ;

        // CasheHelper.saveData(key: 'profileUrl', value: value) ;

        print(value);
        updateCharacter(
          name: name,
          type: type,
          bio: bio,
          image: value,
          index: index,
        );
        emit(UpdateCharacterProfileSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(UpdateCharacterProfileErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(UpdateCharacterProfileErrorState());
    });
  }

  void updateCoverImage({
    required String name,
    required String type,
    required String bio,
    required int index,
  }) {
    emit(UpdateCharacterLoadingState());
    deleteImages('cover' , index);
    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('users/$uId/characters/${charId[index]}/cover/${Uri
        .file(characterCoverImage!.path)
        .pathSegments
        .last}')
        .putFile(characterCoverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {

        characterCoverUrl = value ;
        // CasheHelper.saveData(key: 'coverUrl', value: value) ;

        // print(value);
        updateCharacter(
          name: name,
          type: type,
          bio: bio,
          cover: value,
          index: index,
        );

        emit(UpdateCharacterCoverSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(UpdateCharacterCoverErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(UpdateCharacterCoverErrorState());
    });
  }

  void updateCharacter({
    required String name,
    required String type,
    required String bio,
    required int index,
    String ? cover ,
    String ? image ,
    String ? date ,
  }){

  if(isAvatarImage){
    emit(UpdateCharacterLoadingState());
      deleteImages('profile' , index);
        getImageFileFromAssets().then((value) {
          firebase_storage.FirebaseStorage
            .instance
            .ref()
            .child('users/$uId/characters/${charId[index]}/profile/${Uri
            .file(testFile!.path)
            .pathSegments
            .last}')
            .putFile(testFile!)
            .then((value) {
          value.ref.getDownloadURL().then((value) {
                  emit(UpdateCharacterLoadingState());
                  CharacterDataModel model = CharacterDataModel(
                    name: name,
                    type: type,
                    // email: userData!.email,
                    // uId: userData!.uId,
                    cover: cover ?? charModel[index].cover,
                    image: value,
                    date: charModel[index].date,
                    bio: bio,
                  );
                  FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(uId)
                      .collection('characters')
                      .doc(charId[index])
                      .update(model.toMap())
                      .then((value) {
                    getMostChatting();
                    getCharacters();
                    emit(UpdateCharacterSuccessState());
                  })
                      .catchError((error) {
                    emit(UpdateCharacterErrorState());
                  });
               });
            });
        });
    }
    else {
      emit(UpdateCharacterLoadingState());
      CharacterDataModel model = CharacterDataModel(
        name: name,
        type: type,
        // email: userData!.email,
        // uId: userData!.uId,
        cover: cover ?? charModel[index].cover,
        image: image ?? charModel[index].image,
        date: charModel[index].date,
        bio: bio,
      );
      FirebaseFirestore
          .instance
          .collection('users')
          .doc(uId)
          .collection('characters')
          .doc(charId[index])
          .update(model.toMap())
          .then((value) {
        getMostChatting();
        getCharacters();
        emit(UpdateCharacterSuccessState());
      })
          .catchError((error) {
        emit(UpdateCharacterErrorState());
      });
    }
  }

  void updateAllOfThem({
    required String name,
    required String type,
    required String bio,
    required int index,

  }){

    emit(UpdateCharacterLoadingState());

      deleteImages('profile' , index);

    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('users/$uId/characters/${charId[index]}/profile/${Uri
        .file(characterProfileImage!.path)
        .pathSegments
        .last}')
        .putFile(characterProfileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {

        characterProfileUrl = value ;
        // CasheHelper.saveData(key: 'profileUrl', value: value) ;
        print(value);

        updateCharacter(
          name: name,
          type: type,
          bio: bio,
          image: value,
          index: index,
        );

        updateCoverImage(
          name: name,
          type: type,
          bio: bio,
          index: index,
        );

        emit(UpdateCharacterAllOfThemSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(UpdateCharacterAllOfThemErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(UpdateCharacterAllOfThemErrorState());
    });
  }

  void deleteImages(image , index){


    if(  image == 'profile'&& charModel[index].image!.contains('firebasestorage'))
      {
          // image == 'profile' ?
          firebase_storage.FirebaseStorage
              .instance
              .refFromURL(charModel[index].image!)
              .delete()
              .then((value) {
                // print(value.toString());
            // emit(DeleteSuccessState());
            print("Deleted profile Successfully");
          }).catchError((error){
            print(error.toString());
            // emit(DeleteErrorState());
          });
      }
    else if(  image == 'cover'&& charModel[index].cover!.contains('firebasestorage')) {
          firebase_storage.FirebaseStorage
              .instance
              .refFromURL(charModel[index].cover!)
              .delete()
              .then((value) {
            // print(value.toString());
            // emit(DeleteSuccessState());
            print("Deleted cover Successfully");
          }).catchError((error) {
            print(error.toString());
            // emit(DeleteErrorState());
          });
        }

    else{
      print('noooooooooot found');
    }
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

}



