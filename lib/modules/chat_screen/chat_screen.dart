import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/models/character_data_model/character_data.dart';
import 'package:chatting/modules/character_cubit/character_cubit.dart';
import 'package:chatting/modules/character_cubit/character_states.dart';
import 'package:chatting/modules/chat_details_screen/chat_details_screen.dart';
import 'package:chatting/modules/create_character_screen/create_character_screen.dart';
import 'package:chatting/modules/cubit/chatting_cubit.dart';
import 'package:chatting/modules/cubit/chatting_states.dart';
import 'package:chatting/modules/login_screen/login_screen.dart';
import 'package:chatting/shared/components/components.dart';
import 'package:chatting/shared/remote/cache_helper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/message_model/message_model.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      print('chat screen initState');
      CharacterCubit.get(context).getLastMessages();
      CharacterCubit.get(context).numberOfChats();

  }
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;



    return Builder(builder: (context) {

      // CharacterCubit.get(context).getLastMessages();
      // CharacterCubit.get(context).numberOfChats();
      //
      return BlocConsumer<ChattingCubit, ChattingStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocConsumer<CharacterCubit, CharacterStates>(
            listener: (context, state) {
              if (state is DeleteCharactersSuccessState) Navigator.pop(context);
            },
            builder: (context, state) {
              var cubit = CharacterCubit.get(context);
              var profileImage =
                  CharacterCubit.get(context).characterProfileImage;
              var coverImage = CharacterCubit.get(context).characterCoverImage;

              var mainUser = ChattingCubit.get(context).userData;

              return GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Scaffold(
                  body: NestedScrollView(
                    physics: BouncingScrollPhysics(),
                    floatHeaderSlivers: true,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          floating: true,
                          snap: true,
                          title: Text(
                            'Chats',
                          ),
                          systemOverlayStyle: SystemUiOverlayStyle(
                              statusBarColor:
                                  Colors.transparent.withOpacity(0.05),
                              statusBarIconBrightness: Brightness.dark),
                          elevation: 5,
                          shadowColor: defaultGrey.withOpacity(0.5),
                          forceElevated: true,
                          toolbarHeight: screenHeight * 0.07,
                          // backgroundColor: defaultTeal,
                          actions: [
                            IconButton(
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Column(
                                          children: [
                                            Icon(
                                              IconBroken.Danger,
                                              color: Colors.red,
                                              size: screenHeight * 0.045,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Are you sure you want to logout!',
                                              style: TextStyle(
                                                letterSpacing: 0.5,
                                                height: 0,
                                                fontFamily: 'schoolBook',
                                                fontSize: screenHeight * 0.02,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        contentPadding:
                                            EdgeInsetsDirectional.only(
                                          start: 50,
                                          end: 30,
                                          top: 12,
                                          bottom: 0,
                                        ),
                                        actionsPadding:
                                            EdgeInsetsDirectional.only(
                                          // start: 50,
                                          end: 30,
                                          // top: 12,
                                          bottom: 10,
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              // cubit.getCharacters();
                                              Navigator.pop(
                                                  context); //close Dialog
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontSize: screenHeight * 0.03,
                                                // color: Colors.red,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                // backgroundColor: Colors.red,
                                                foregroundColor: Colors.red),
                                            onPressed: () {
                                              // FirebaseAuth.instance.currentUser!.delete();
                                              cubit.max = 0;
                                              cubit.mostChatting = CharacterDataModel();
                                              cubit.lastMessages =List.filled(10, MessageModel()) ;
                                              signOut(context);
                                            },
                                            child: Text(
                                              'Logout',
                                              style: TextStyle(
                                                fontSize: screenHeight * 0.03,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(
                                IconBroken.Logout,
                                color: Colors.redAccent,
                                size: screenHeight * 0.035,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.015,
                            )
                          ],
                        ),
                      ];
                    },
                    body: ConditionalBuilder(
                      condition: cubit.charModel.length > 0,
                      builder: (context) => Padding(
                        padding: const EdgeInsetsDirectional.only(
                          top: 0.0,
                        ),
                        child: RefreshIndicator(
                          onRefresh: ()async{
                            // cubit.getCharacters();
                            setState(() {});
                            return Future<void>.delayed(const Duration(seconds: 1));
                            } ,
                          backgroundColor: defaultWhite,
                          color: defaultTealAccent,
                          // strokeWidth: screenHeight*0.005,


                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Column(
                              children: [
                                // if(index == 0)
                                //   SizedBox(height: screenHeight*0.025,),

                                Slidable(
                                    endActionPane: ActionPane(
                                      extentRatio: 0.5,
                                      motion: StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          borderRadius: BorderRadius.circular(15),
                                          icon: IconBroken.Delete,
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Colors.red,
                                          autoClose: true,
                                          label: 'Delete Conversation',
                                          spacing: 10,

                                          onPressed: (BuildContext context) {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Row(
                                                      children: [
                                                        Icon(
                                                          IconBroken.Danger,
                                                          color: Colors.red,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          'Take Care',
                                                          style: TextStyle(
                                                            letterSpacing: 1,
                                                            height: 0,
                                                            fontFamily:
                                                                'schoolBook',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    content: Text(
                                                      'The entire conversation will be deleted.',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 0.5,
                                                        height: 1.25,
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsetsDirectional
                                                            .only(
                                                      start: 30,
                                                      end: 30,
                                                      top: 12,
                                                      bottom: 0,
                                                    ),
                                                    actionsPadding:
                                                        EdgeInsetsDirectional
                                                            .only(
                                                      // start: 50,
                                                      end: 30,
                                                      // top: 12,
                                                      bottom: 10,
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          // cubit.getCharacters();
                                                          Navigator.pop(
                                                              context); //close Dialog
                                                        },
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.03,
                                                            // color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        style:
                                                            TextButton.styleFrom(
                                                                // backgroundColor: Colors.red,
                                                                foregroundColor:
                                                                    Colors.red),
                                                        onPressed: () {
                                                          cubit.deleteConversation(
                                                              context,
                                                              receiverId: cubit
                                                                  .charId[index]);
                                                          // CharacterCubit.get(context).deleteMessages(receiverId: receiverId, date: model.dateTime);
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.03,
                                                                color: Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            if (state
                                                                is DeletingLoadingState)
                                                              Container(
                                                                  width:
                                                                      screenWidth *
                                                                          0.1,
                                                                  child:
                                                                      LinearProgressIndicator(
                                                                    color:
                                                                        defaultTealAccent,
                                                                    minHeight: 3,
                                                                  ))
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          // padding: EdgeInsets.fromLTRB(0, 0, 5, 10),
                                        ),
                                      ],
                                    ),
                                    child: characterItem(
                                        context, index, cubit.charModel[index])),
                                if (index ==
                                    CharacterCubit.get(context).charSize! - 1)
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * 0.15,
                                  )
                              ],
                            ),
                            separatorBuilder: (context, index) => SizedBox(
                              height: screenHeight * 0.025,
                            ),
                            itemCount: cubit.charSize!,
                          ),
                        ),
                      ),
                      fallback: (context) => Center(
                          child: CircularProgressIndicator(
                        color: defaultTealAccent,
                      )),
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }

  Widget characterItem(context, index, CharacterDataModel charModel) => InkWell(
        onTap: () {
          // print(charModel.);
          print(CharacterCubit.get(context).charId[index]);
          navigateTo(
              context,
              ChatDetailsScreen(
                  charModel,
                  CharacterCubit.get(context).charId[index],
                  ChattingCubit.get(context).userData));
        },
        // overlayColor: MaterialStateProperty.all(Colors.red),
        highlightColor: Colors.redAccent.withOpacity(0.8),

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13),
          topRight: Radius.circular(13),
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
              top: MediaQuery.of(context).size.height * 0.005),
          child: Column(
            children: [
              Container(
                // height: screenHeight*0.15,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: defaultWhite,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: defaultTealAccent.withOpacity(0.7),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: defaultTealAccent.withOpacity(0.5),
                        radius: MediaQuery.of(context).size.height*0.04,
                        child: CircleAvatar(
                          backgroundColor: defaultAvatar,
                          radius: MediaQuery.of(context).size.height * 0.038,
                          backgroundImage: CachedNetworkImageProvider(
                            '${charModel.image}',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // 'Sohaib' ,
                            '${charModel.name}',
                            style: TextStyle(
                              fontFamily: 'schoolBook',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.0,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.028,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CharacterCubit.get(context).lastMessages[index].messageImage != null || CharacterCubit.get(context).lastMessages[index].text !=null ?
                              // index+1 <= CharacterCubit.get(context).lastMessages.length   ?
                              CharacterCubit.get(context)
                                          .lastMessages[index]
                                          .senderId ==
                                      uId
                                  ? Row(
                                      children: [
                                        Text(
                                          ' You: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.032,
                                                  letterSpacing: 0.5,
                                                  // color: Colors.deepPurple,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            CharacterCubit.get(context)
                                                        .lastMessages[index]
                                                        .text!
                                                        .length !=
                                                    0
                                                ? '${CharacterCubit.get(context).lastMessages[index].text}'
                                                : 'sent an image...',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.032,
                                                    letterSpacing: 0.5,
                                                    // color: Colors.deepPurple,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        CharacterCubit.get(context)
                                                    .lastMessages[index]
                                                    .text!
                                                    .length !=
                                                0
                                            ?
                                            // CharacterCubit.get(context).lastMessages[index].text != null ?
                                            '${CharacterCubit.get(context).lastMessages[index].text}'
                                            : 'an image sent...',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.032,
                                              letterSpacing: 0.5,
                                              // color: defaultTealAccent.withOpacity(0.7),
                                            ),
                                      ),
                                    )
                              : Row(
                                  children: [
                                    Text(
                                      // '${charModel.bio}',
                                      ' Say Hi ',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.032,
                                            letterSpacing: 0.5,
                                            // color: Colors.purple
                                          ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          bottom: 3),
                                      child: Icon(
                                        IconBroken.Heart,
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // if(index == CharacterCubit.get(context).charSize!-1)
              //   SizedBox(height: MediaQuery.of(context).size.height*0.15,)
            ],
          ),
        ),
      );
}
