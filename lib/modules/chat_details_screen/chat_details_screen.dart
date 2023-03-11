import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/models/character_data_model/character_data.dart';
import 'package:chatting/models/user_data_model/user_data.dart';
import 'package:chatting/modules/character_cubit/character_cubit.dart';
import 'package:chatting/modules/character_cubit/character_states.dart';
import 'package:chatting/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:intl/intl.dart';

import '../../../shared/styles/icon_broken.dart';
import '../../models/message_model/message_model.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class ChatDetailsScreen extends StatefulWidget {

CharacterDataModel ? charModel ;
String ? receiverId ;
UserDataModel ? mainUser ;


ChatDetailsScreen(
    this.charModel,
    this.receiverId,
    this.mainUser,
    );

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {

var textController  = TextEditingController();
var scrollController  = ScrollController();
// static AudioCache player =  AudioCache();


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    // scrollDown1(scrollController);
  }

@override
  @override
  Widget build(BuildContext context) {

    var screenHeight =  MediaQuery.of(context).size.height ;
    var screenWidth =  MediaQuery.of(context).size.width ;



      return Builder(
      builder: (context) {
        if(MediaQuery.of(context).viewInsets.bottom == 0.0)
          CharacterCubit.get(context).getMessages(receiverId: widget.receiverId,) ;
        // CharacterCubit.get(context).getLastMessages();


        return BlocConsumer<CharacterCubit, CharacterStates>(
          listener: (context , state){
            if(state is GetMessagesSuccessState ) {
              scrollDown(scrollController);
            }
          },
          builder: (context , state){

            var cubit = CharacterCubit.get(context);
            var messages = cubit.messages ;

            return  GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              // {
              //   FocusScopeNode currentFocus = FocusScope.of(context);
              //
              //   if (!currentFocus.hasPrimaryFocus) {
              //     currentFocus.unfocus();
              //   }
              // },
              child: Scaffold(

                appBar:AppBar(
                  elevation: 10,
                    systemOverlayStyle: SystemUiOverlayStyle(
                      // statusBarColor: defaultTeal,
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(15),
                      ),
                    ),
                    backgroundColor: defaultTealAccent.withOpacity(0.7),
                    // backgroundColor: cubit.color.withOpacity(0.7),
                  titleSpacing: 5.0,
                  title: cubit.isMe ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                          backgroundColor: defaultWhite,
                          radius: MediaQuery.of(context).size.height*0.03,
                        child: FullScreenWidget(
                          disposeLevel: DisposeLevel.High,
                          child: CircleAvatar(
                                backgroundColor: defaultAvatar,
                            radius: MediaQuery.of(context).size.height*0.028,
                            backgroundImage:   CachedNetworkImageProvider(
                              // 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465',
                              '${widget.charModel!.image}',

                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                      Container(
                        width: MediaQuery.of(context).size.width*0.65 ,
                        child: Text(
                          // 'Sohaib' ,
                          '${widget.charModel!.name}',
                          style: TextStyle(
                            fontFamily: 'schoolBook',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            fontSize: MediaQuery.of(context).size.height*0.023,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ) :
                    Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                          backgroundColor: defaultWhite,
                          radius: MediaQuery.of(context).size.height*0.03,
                        child: FullScreenWidget(
                          child: Transform(
                          alignment: Alignment.center,
                           transform: widget.mainUser!.image!.contains('char') && ! widget.mainUser!.image!.contains('image_cropper')  ? Matrix4.rotationY(pi) : Matrix4.rotationY(0),
                              child: CircleAvatar(
                                backgroundColor: defaultAvatar,
                                radius: MediaQuery.of(context).size.height*0.028,
                                backgroundImage:   CachedNetworkImageProvider(
                                 // 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465',
                                 '${widget.mainUser!.image}',
                                ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                      Container(
                        // height: MediaQuery.of(context).size.height*0.025,
                        width: MediaQuery.of(context).size.width*0.6,
                        child: Text(
                          // 'Sohaib' ,
                          '${widget.mainUser!.name}',
                          style: TextStyle(
                            fontFamily: 'schoolBook',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                            fontSize: MediaQuery.of(context).size.height*0.023,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ) ,
                  // leading: backArrow(context, iconColor: Colors.black.withOpacity(0.75) , iconSize: screenHeight*0.05 , isLastMessage: true ),
                  leading: IconButton(
                    onPressed: (){
                      // cubit.max = 0 ;
                      print(cubit.max);
                      cubit.getLastMessages().then((value){
                        cubit.numberOfChats().then((value) {
                          Navigator.pop(context);
                        });
                      });
                    },
                      icon: Icon(
                    IconBroken.Arrow___Left_2,
                    color: Colors.black.withOpacity(0.75),
                    size: screenHeight*0.05,
                  ),
                  ),
                ) ,
                body: ConditionalBuilder(
                  condition: messages.length > 0 ,
                  // condition:true,
                  builder: (context) => Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 0,
                      bottom: 8,
                      end: 8,
                      start: 8,
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          // color: Colors.redAccent,
                          child: Padding(
                            padding:  EdgeInsetsDirectional.only(top: screenHeight*0.0),
                            child: Column(
                              children: [

                                Expanded(
                                  child: ListView.separated(
                                    controller: scrollController ,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context , index) {
                                      if(uId == messages[index].senderId ){
                                        if(messages[index].messageImage != null)
                                          return Column(
                                            children: [
                                              if(index == 0)
                                                SizedBox(height: screenHeight*0.04,),

                                              buildMyImageMessage(context , index,messages[index]),

                                              if(index == messages.length-1)
                                                SizedBox(height: screenHeight*0.1,),

                                              if(index == messages.length-1 && cubit.messageImage != null )
                                                SizedBox(height: screenHeight*0.25,),
                                            ],
                                          ) ;
                                        else
                                          return Column(
                                            children: [
                                              if(index == 0)
                                                SizedBox(height: screenHeight*0.04,),

                                              buildMyMessage( context , messages[index] ),

                                              if(index == messages.length-1)
                                                SizedBox(height: screenHeight*0.1,),

                                              if(index == messages.length-1 && cubit.messageImage != null )
                                                SizedBox(height: screenHeight*0.25,),
                                            ],
                                          ) ;
                                      }

                                        else {
                                        if (messages[index].messageImage == null)
                                          return Column(
                                            children: [
                                              if(index == 0)
                                                SizedBox(
                                                  height: screenHeight * 0.04,),

                                              buildMessage(context, messages[index]),

                                              if(index == messages.length - 1)
                                                SizedBox(
                                                  height: screenHeight * 0.1,),

                                              if(index == messages.length - 1 &&
                                                  cubit.messageImage != null )
                                                SizedBox(
                                                  height: screenHeight * 0.25,),

                                            ],
                                          );

                                        else
                                          return Column(
                                            children: [
                                              if(index == 0)
                                                SizedBox(height: screenHeight * 0.04,),

                                              buildImageMessage(context, messages[index]),

                                              if(index == messages.length - 1)
                                                SizedBox(
                                                  height: screenHeight * 0.1,),

                                              if(index == messages.length - 1 &&
                                                  cubit.messageImage != null )
                                                SizedBox(
                                                  height: screenHeight * 0.25,),

                                            ],
                                          );
                                      }
                                    } ,
                                      separatorBuilder: (context, index) => SizedBox(height: 10,),
                                      itemCount: messages.length,
                                      // itemCount: 25,
                                  ),
                                ),
                                // if(cubit.messageImage != null)
                                //   SizedBox(height: screenHeight*0.25,),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            if(cubit.messageImage != null && cubit.isMe)
                            // cubit.messageImage != null && cubit.isMe ?
                              Padding(
                                padding:  EdgeInsetsDirectional.only(
                                    top: 5.0 ,
                                    bottom: 5.0 ,
                                    end: screenWidth*0.15,
                                ),
                                child: Container(
                                    height: screenHeight*0.2,
                                    width: screenWidth,

                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            offset:Offset(2,-2),
                                            color: defaultWhite,
                                            blurRadius: 5,
                                          ),
                                          BoxShadow(
                                            offset:Offset(-2,2),
                                            color: defaultWhite,
                                            blurRadius: 5,
                                          ),
                                        ]
                                      ),
                                      child: Image(
                                          image: FileImage(cubit.messageImage!) as ImageProvider ,
                                          fit: BoxFit.fitHeight,
                                        ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: (){
                                          cubit.removeMessageImage();
                                        },
                                        highlightColor: defaultTealAccent.withOpacity(0.8),
                                        child: CircleAvatar(
                                          radius: screenHeight*0.025,
                                          backgroundColor: defaultTealAccent,
                                          child:  Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: screenHeight*0.03,
                                          ) ,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ),
                              ) ,

                            if(cubit.messageImage != null && cubit.isMe == false)

                            Padding(
                              padding:  EdgeInsetsDirectional.only(
                                top: 5.0 ,
                                bottom: 5.0 ,
                                start: screenWidth*0.02,
                              ),
                              child: Container(
                                height: screenHeight*0.2,
                                width: screenWidth,

                                child: Stack(
                                  alignment: AlignmentDirectional.topStart,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              offset:Offset(2,-2),
                                              color: defaultWhite,
                                              blurRadius: 5,
                                            ),
                                            BoxShadow(
                                              offset:Offset(-2,2),
                                              color: defaultWhite,
                                              blurRadius: 5,
                                            ),
                                          ]
                                      ),
                                      child: Image(
                                        image: FileImage(cubit.messageImage!) as ImageProvider ,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: (){
                                          cubit.removeMessageImage();
                                        },
                                        highlightColor: defaultTealAccent.withOpacity(0.8),
                                        child: CircleAvatar(
                                          radius: screenHeight*0.025,
                                          backgroundColor: defaultTealAccent,
                                          child:  Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: screenHeight*0.03,
                                          ) ,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if(CharacterCubit.get(context).uploadingMessageImage)
                              Padding(
                                padding:  EdgeInsetsDirectional.only(start: screenWidth*0.034 ,end: screenWidth*0.18 ,bottom: screenHeight*0.003),
                                child: LinearProgressIndicator(
                                  color: defaultTealAccent,
                                  backgroundColor: Colors.transparent,
                                  minHeight: screenHeight*0.003,
                                ),
                              ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(end: 2.0 , bottom: 5),
                                    child: Container(
                                      // height: screenHeight*0.06,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          color: defaultWhite,
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            width: 1,
                                            color: defaultTealAccent,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0,-2),
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 3,
                                            ),
                                            BoxShadow(
                                              offset: Offset(0,1),
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 3,
                                            ),
                                          ]

                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:  EdgeInsetsDirectional.only(start: screenWidth*0.03, bottom: screenHeight*0.00),
                                              child: TextFormField(
                                                keyboardType: TextInputType.multiline,
                                                maxLines: 5,
                                                minLines: 1,
                                                style: TextStyle(
                                                  fontSize: screenHeight*0.025,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  letterSpacing: 1,
                                                ),
                                                cursorColor: defaultTealAccent,
                                                cursorHeight: screenHeight*0.025,
                                                controller: textController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'type here ...',
                                                  hintStyle: TextStyle(
                                                    // height: 0.2,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:  EdgeInsetsDirectional.only( bottom: screenHeight*0.0 , end: screenWidth*0.01),
                                            child: IconButton(
                                              highlightColor: Colors.transparent,
                                              onPressed: (){
                                                cubit.getMessageImage();
                                              },
                                              icon: Icon(
                                                IconBroken.Image,
                                                color: defaultTealAccent,
                                                size: screenHeight*0.045,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // height: screenHeight*0.08,
                                            decoration: BoxDecoration(
                                              color: defaultTealAccent,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                              ),
                                            ),

                                            child: MaterialButton(
                                              enableFeedback: false,
                                              highlightColor: defaultTealAccent.withOpacity(0.5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)
                                              ),
                                              minWidth: 1,
                                              onPressed: (){
                                                if(cubit.messageImage == null ) {
                                                  if(textController.text.trim().length > 0) {
                                                    if (cubit.isMe == true) {
                                                      cubit.sendMessage(
                                                        text: textController.text.trimRight(),
                                                        receiverId: widget.receiverId,
                                                        dateTime: DateTime.now().toString(),
                                                      );
                                                    }
                                                    else {
                                                      cubit.sendMessage(
                                                        text: textController.text.trimRight(),
                                                        receiverId: uId,
                                                        senderId: widget.receiverId,
                                                        dateTime: DateTime.now().toString(),
                                                      );
                                                      print(
                                                          '$uId \n ${widget.receiverId}');
                                                    }
                                                  }
                                                }
                                                else{
                                                  cubit.isMe ?
                                                  cubit.uploadMessageImage(
                                                      receiverId: widget.receiverId,
                                                      dateTime: DateTime.now().toString() ,
                                                      text: textController.text.trimRight(),
                                                    senderId: uId,
                                                  ):
                                                  cubit.uploadMessageImage(
                                                      text: textController.text.trimRight(),
                                                      receiverId: uId,
                                                      senderId: widget.receiverId,
                                                      dateTime: DateTime.now().toString(),
                                                  );

                                                  cubit.removeMessageImage();
                                                }
                                                textController = TextEditingController() ;
                                                AudioPlayer().play(AssetSource('sounds/send.mp3'));
                                                //                   player.play('sounds/send.mp3');

                                              },
                                              child: Icon(
                                                IconBroken.Send,
                                                size: screenHeight*0.035,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  enableFeedback: false,
                                  onTap: (){
                                    cubit.switchSender();
                                    cubit.switchColor();
                                    // print(cubit.isMe);
                                    AudioPlayer().play(AssetSource('sounds/swipe.mp3'));
                                  },
                                  customBorder: CircleBorder(),
                                  highlightColor: Colors.transparent,
                                  // splashColor: defaultTealAccent.withOpacity(0.4),
                                  splashColor: Colors.transparent,
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      CircleAvatar(
                                        // radius: screenHeight*0.05,
                                        backgroundColor: Colors.white.withOpacity(0.8),
                                      ),
                                      Transform(
                                         alignment: Alignment.center,
                                          transform: ! cubit.isMe? Matrix4.rotationY(pi) : Matrix4.rotationY(0) ,
                                         child: Icon(
                                          // Icons.change_circle_outlined ,
                                          Icons.change_circle ,
                                          // color: defaultTealAccent,
                                          color: cubit.color,
                                          size: screenHeight*0.07,

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  fallback: (context) => Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 0,
                      bottom: 5,
                      end: 5,
                      start: 5,
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                controller: scrollController,
                                  itemBuilder:(context , index) =>  Center(
                                    child: Padding(
                                      padding:  EdgeInsetsDirectional.only(top: screenHeight*0.35),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Say Hi to yourself',
                                            style: Theme.of(context).textTheme.caption!.copyWith(
                                              fontSize: screenHeight*0.05
                                            ),
                                          ),
                                          SizedBox(height: screenHeight*0.015,),
                                          IconButton(
                                            highlightColor: Colors.transparent,
                                            onPressed: (){
                                              cubit.isMe ?
                                              cubit.sendMessage(
                                                  text: 'Hi',
                                                  receiverId: widget.receiverId,
                                                  dateTime: DateTime.now().toString(),
                                              ) :
                                              cubit.sendMessage(
                                                text: 'Hi',
                                                receiverId: uId,
                                                senderId: widget.receiverId,
                                                dateTime: DateTime.now().toString(),
                                              );
                                            } ,
                                            icon: Icon(
                                              // IconBroken.Heart,
                                              Icons.waving_hand_outlined,
                                              size: screenHeight*0.065,
                                              color: defaultTeal.withOpacity(0.8),
                                            ),
                                          ),
                                          // SizedBox(height: screenHeight*0.5,),
                                        ],
                                      ),
                                    ),
                                  ),
                                separatorBuilder: (context , index) => SizedBox(height: 0,),
                                itemCount: 1,
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            if(cubit.messageImage != null && cubit.isMe)
                            // cubit.messageImage != null && cubit.isMe ?
                              Padding(
                                padding:  EdgeInsetsDirectional.only(
                                    top: 5.0 ,
                                    bottom: 5.0 ,
                                    end: screenWidth*0.13,
                                ),
                                child: Container(
                                    height: screenHeight*0.25,
                                    width: screenWidth,

                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            offset:Offset(2,-2),
                                            color: defaultWhite,
                                            blurRadius: 5,
                                          ),
                                          BoxShadow(
                                            offset:Offset(-2,2),
                                            color: defaultWhite,
                                            blurRadius: 5,
                                          ),
                                        ]
                                      ),
                                      child: Image(
                                          image: FileImage(cubit.messageImage!) as ImageProvider ,
                                          fit: BoxFit.fitHeight,
                                        ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: (){
                                          cubit.removeMessageImage();
                                        },
                                        highlightColor: defaultTealAccent.withOpacity(0.8),
                                        child: CircleAvatar(
                                          radius: screenHeight*0.025,
                                          backgroundColor: defaultTealAccent,
                                          child:  Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: screenHeight*0.03,
                                          ) ,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ),
                              ) ,

                            if(cubit.messageImage != null && cubit.isMe == false)

                            Padding(
                              padding:  EdgeInsetsDirectional.only(
                                top: 5.0 ,
                                bottom: 5.0 ,
                                start: screenWidth*0.02,
                              ),
                              child: Container(
                                height: screenHeight*0.25,
                                width: screenWidth,

                                child: Stack(
                                  alignment: AlignmentDirectional.topStart,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              offset:Offset(2,-2),
                                              color: defaultWhite,
                                              blurRadius: 5,
                                            ),
                                            BoxShadow(
                                              offset:Offset(-2,2),
                                              color: defaultWhite,
                                              blurRadius: 5,
                                            ),
                                          ]
                                      ),
                                      child: Image(
                                        image: FileImage(cubit.messageImage!) as ImageProvider ,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: (){
                                          cubit.removeMessageImage();
                                        },
                                        highlightColor: defaultTealAccent.withOpacity(0.8),
                                        child: CircleAvatar(
                                          radius: screenHeight*0.025,
                                          backgroundColor: defaultTealAccent,
                                          child:  Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: screenHeight*0.03,
                                          ) ,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if(CharacterCubit.get(context).uploadingMessageImage)
                              Padding(
                                padding:  EdgeInsetsDirectional.only(start: screenWidth*0.035 ,end: screenWidth*0.19 ,bottom: screenHeight*0.003),
                                child: LinearProgressIndicator(
                                  color: defaultTealAccent,
                                  backgroundColor: defaultGrey.withOpacity(0.2),
                                ),
                              ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Container(
                                      // height: screenHeight*0.06,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          color: defaultWhite,
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            width: 1,
                                            color: defaultTealAccent,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0,-2),
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 3,
                                            ),
                                            BoxShadow(
                                              offset: Offset(0,1),
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 3,
                                            ),
                                          ]

                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:  EdgeInsetsDirectional.only(start: screenWidth*0.03, bottom: screenHeight*0.00),
                                              child: TextFormField(
                                                keyboardType: TextInputType.multiline,
                                                maxLines: 5,
                                                minLines: 1,
                                                style: TextStyle(
                                                  fontSize: screenHeight*0.025,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  letterSpacing: 1,
                                                ),
                                                cursorColor: defaultTealAccent,
                                                cursorHeight: screenHeight*0.025,
                                                controller: textController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'type here ...',
                                                  hintStyle: TextStyle(
                                                    // height: 0.2,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:  EdgeInsetsDirectional.only( bottom: screenHeight*0.00 , end: screenWidth*0.01),
                                            child: IconButton(
                                              highlightColor: Colors.transparent,
                                              onPressed: (){
                                                cubit.getMessageImage();
                                              },
                                              icon: Icon(
                                                IconBroken.Image,
                                                color: defaultTealAccent,
                                                size: screenHeight*0.045,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            // height: screenHeight*0.08,
                                            decoration: BoxDecoration(
                                              color: defaultTealAccent,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                              ),
                                            ),

                                            child: MaterialButton(
                                              highlightColor: defaultTealAccent.withOpacity(0.5),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)
                                              ),
                                              minWidth: 1,
                                              onPressed: (){
                                                if(cubit.messageImage == null ) {
                                                  if(textController.text.trim().length > 0) {
                                                    if (cubit.isMe == true) {
                                                      cubit.sendMessage(
                                                        text: textController.text.trimRight(),
                                                        receiverId: widget.receiverId,
                                                        dateTime: DateTime.now().toString(),
                                                      );
                                                    }
                                                    else {
                                                      cubit.sendMessage(
                                                        text: textController.text.trimRight(),
                                                        receiverId: uId,
                                                        senderId: widget.receiverId,
                                                        dateTime: DateTime.now().toString(),
                                                      );
                                                      print(
                                                          '$uId \n ${widget.receiverId}');
                                                    }
                                                  }
                                                }
                                                else{
                                                  cubit.isMe ?
                                                  cubit.uploadMessageImage(
                                                      receiverId: widget.receiverId,
                                                      dateTime: DateTime.now().toString() ,
                                                      text: textController.text.trimRight(),
                                                    senderId: uId,
                                                  ):
                                                  cubit.uploadMessageImage(
                                                      text: textController.text.trimRight(),
                                                      receiverId: uId,
                                                      senderId: widget.receiverId,
                                                      dateTime: DateTime.now().toString(),
                                                  );

                                                  cubit.removeMessageImage();
                                                }
                                                textController = TextEditingController() ;
                                              },
                                              child: Icon(
                                                IconBroken.Send,
                                                size: screenHeight*0.035,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    cubit.switchSender();
                                    cubit.switchColor();
                                    print(cubit.isMe);
                                  },
                                  customBorder: CircleBorder(),
                                  highlightColor: Colors.transparent,
                                  splashColor: defaultTealAccent.withOpacity(0.4),
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [

                                      CircleAvatar(
                                        // radius: screenHeight*0.05,
                                        backgroundColor: Colors.white.withOpacity(0.8),
                                      ),
                                      Icon(
                                        // Icons.change_circle_outlined ,
                                        Icons.change_circle ,
                                        // color: defaultTealAccent,
                                        color: cubit.color,
                                        size: screenHeight*0.075,

                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // fallback: (context) => Center(child: Text('Say hi to ${charModel!.name}')),
                ),
              ),
            ) ;
          },
        );
      }
    );
  }

  Widget buildMessage(context ,MessageModel  model) => Slidable(

    startActionPane:  ActionPane(
      extentRatio: 0.13,
      motion: StretchMotion(),
      children: [
        SlidableAction(
          borderRadius: BorderRadius.circular(15), onPressed: (BuildContext context) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          IconBroken.Danger,
                          color: Colors.red,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          'Take Care',
                          style: TextStyle(
                            letterSpacing: 1,
                            height: 0,
                            fontFamily: 'schoolBook',
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                      'You can\'t get this message again.',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        height: 1.25,
                      ),
                    ),
                    contentPadding: EdgeInsetsDirectional.only(
                      start: 50,
                      end: 30,
                      top: 12,
                      bottom: 0,
                    ),
                    actionsPadding: EdgeInsetsDirectional.only(
                      // start: 50,
                      end: 30,
                      // top: 12,
                      bottom: 10,
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          // cubit.getCharacters();
                          Navigator.pop(context);//close Dialog
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height*0.03,
                            // color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          // backgroundColor: Colors.red,
                            foregroundColor: Colors.red
                        ),
                        onPressed: () {
                          // cubit.deleteCharacter(index , context);
                          CharacterCubit.get(context).deleteMessages(context ,receiverId: widget.receiverId, date: model.dateTime);
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height*0.03,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      ),
                    ],
                  );
                }
            );

          },
          icon: IconBroken.Delete,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.red,
          autoClose: true,
          padding: EdgeInsets.fromLTRB(0, 0, 5, 10),
        ),
      ],
    ),

    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding:  EdgeInsetsDirectional.only(
            top: MediaQuery.of(context).size.height*0.0015,
            bottom: MediaQuery.of(context).size.height*0.0015,
            end: MediaQuery.of(context).size.width*0.2,
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: defaultGrey.withOpacity(0.25),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: SelectableText(
                '${model.text}' ,
                // 'hello' ,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height*0.022,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  height: 1.1,
                  color: Colors.black.withOpacity(0.75),
                ),


              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 2,
                start: 3,
              ),
              child: Text(
                '${DateFormat.jm().format(DateTime.parse(model.dateTime!))}',
                style: Theme.of(context).textTheme.caption!.copyWith(
                    fontSize: MediaQuery.of(context).size.height*0.011,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),

          ],
        ),
      ),
    ),
  );

  Widget buildMyMessage( context ,MessageModel  model  ) => Slidable(
    endActionPane:  ActionPane(
      extentRatio: 0.13,
      motion: StretchMotion(),
      children: [
        SlidableAction(
          borderRadius: BorderRadius.circular(15),
          onPressed: (BuildContext context) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          IconBroken.Danger,
                          color: Colors.red,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          'Take Care',
                          style: TextStyle(
                            letterSpacing: 1,
                            height: 0,
                            fontFamily: 'schoolBook',
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                      'You can\'t get this message again.',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        height: 1.25,
                      ),
                    ),
                    contentPadding: EdgeInsetsDirectional.only(
                      start: 50,
                      end: 30,
                      top: 12,
                      bottom: 0,
                    ),
                    actionsPadding: EdgeInsetsDirectional.only(
                      // start: 50,
                      end: 30,
                      // top: 12,
                      bottom: 10,
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          // cubit.getCharacters();
                          Navigator.pop(context);//close Dialog
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height*0.03,
                            // color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          // backgroundColor: Colors.red,
                            foregroundColor: Colors.red
                        ),
                        onPressed: () {
                          // cubit.deleteCharacter(index , context);
                          CharacterCubit.get(context).deleteMessages(context , receiverId: widget.receiverId, date: model.dateTime);
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height*0.03,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      ),
                    ],
                  );
                }
            );

          },
          icon: IconBroken.Delete,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.red,
          autoClose: true,
          padding: EdgeInsets.fromLTRB(0, 0, 5, 10),
        ),
      ],
    ),

    child: Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Padding(
            padding:  EdgeInsetsDirectional.only(
                top: MediaQuery.of(context).size.height*0.0015,
                bottom: MediaQuery.of(context).size.height*0.0015,
              start: MediaQuery.of(context).size.width*0.25,

            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: defaultTealAccent.withOpacity(0.25),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SelectableText(
                        '${model.text}' ,
                        // 'Hello bro' ,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height*0.022,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          height: 1.1,
                          color: Colors.black.withOpacity(0.75),
                        ),
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    top: 2,
                    end: 3,
                  ),
                  child: Text(
                    // '${model.dateTime!.substring(11 , 16)}',
                    // ' ${TimeOfDay.fromDateTime(DateTime.parse(model.dateTime!)).toString().substring(10,15)} ${TimeOfDay.fromDateTime(DateTime.parse(model.dateTime!)).period.toString().substring(10)}',
                    '${DateFormat.jm().format(DateTime.parse(model.dateTime!))}',
                    style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: MediaQuery.of(context).size.height*0.011,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // if(index == CharacterCubit.get(context).messages.length-1)
        //   SizedBox(height:MediaQuery.of(context).size.height*0.1 ,),
      ],
    ),
  );

Widget buildMyImageMessage(context , index ,MessageModel model ) => Slidable(
  endActionPane:  ActionPane(
    extentRatio: 0.13,
    motion: StretchMotion(),
    children: [
      SlidableAction(
        borderRadius: BorderRadius.circular(15),
        onPressed: (BuildContext context) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Row(
                    children: [
                      Icon(
                        IconBroken.Danger,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5,),
                      Text(
                        'Take Care',
                        style: TextStyle(
                          letterSpacing: 1,
                          height: 0,
                          fontFamily: 'schoolBook',
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    'You can\'t get this message again.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      height: 1.25,
                    ),
                  ),
                  contentPadding: EdgeInsetsDirectional.only(
                    start: 50,
                    end: 30,
                    top: 12,
                    bottom: 0,
                  ),
                  actionsPadding: EdgeInsetsDirectional.only(
                    // start: 50,
                    end: 30,
                    // top: 12,
                    bottom: 10,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // cubit.getCharacters();
                        Navigator.pop(context);//close Dialog
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height*0.03,
                          // color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        // backgroundColor: Colors.red,
                          foregroundColor: Colors.red
                      ),
                      onPressed: () {
                        // cubit.deleteCharacter(index , context);
                        CharacterCubit.get(context).deleteMessages(context ,receiverId: widget.receiverId, date: model.dateTime);
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height*0.03,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                );
              }
          );
        },
        icon: IconBroken.Delete,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.red,
        autoClose: true, padding: EdgeInsets.fromLTRB(0, 0, 5, 10),
      ),],
  ),
  child:   Column(
    children: [
          Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding:  EdgeInsetsDirectional.only(
                top: MediaQuery.of(context).size.height*0.0015,
                bottom: MediaQuery.of(context).size.height*0.0015,
                start: MediaQuery.of(context).size.width*0.25,
              ),
              child:
              Container(
                // height: MediaQuery.of(context).size.height*0.2,
                // width: MediaQuery.of(context).size.width,
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: FullScreenWidget(
                    child:
                    // Image(
                    //     image:NetworkImage(
                    //       '${model.messageImage}',
                    //     ) ,
                    //     // fit: BoxFit.fitHeight,
                    //     fit: BoxFit.fitWidth,
                    //   ) ,
                  cachedImage(image:  '${model.messageImage}' , height: MediaQuery.of(context).size.height*0.2),
                    ),
                  ),
                ),
              ),
            if(! model.text!.trim().isEmpty)
              SizedBox(height: 4,),
            if(! model.text!.trim().isEmpty)
              Container(
              padding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: defaultTealAccent.withOpacity(0.25),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: SelectableText(
                '${model.text}' ,
                // 'loool' ,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height*0.022,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  height: 1.1,
                  color: Colors.black.withOpacity(0.75),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 2,
                end: 3,
              ),
              child: Text(
                '${DateFormat.jm().format(DateTime.parse(model.dateTime!))}',
                style: Theme.of(context).textTheme.caption!.copyWith(
                    fontSize: MediaQuery.of(context).size.height*0.011,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
          ],
        ),
      ),

    ],
  ),
);

Widget buildImageMessage(context  ,MessageModel model ) => Slidable(
  startActionPane:  ActionPane(
    extentRatio: 0.13,
    motion: StretchMotion(),
    children: [
      SlidableAction(
        borderRadius: BorderRadius.circular(15),
        onPressed: (BuildContext context) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Row(
                    children: [
                      Icon(
                        IconBroken.Danger,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5,),
                      Text(
                        'Take Care',
                        style: TextStyle(
                          letterSpacing: 1,
                          height: 0,
                          fontFamily: 'schoolBook',
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    'You can\'t get this message again.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      height: 1.25,
                    ),
                  ),
                  contentPadding: EdgeInsetsDirectional.only(
                    start: 50,
                    end: 30,
                    top: 12,
                    bottom: 0,
                  ),
                  actionsPadding: EdgeInsetsDirectional.only(
                    // start: 50,
                    end: 30,
                    // top: 12,
                    bottom: 10,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        // cubit.getCharacters();
                        Navigator.pop(context);//close Dialog
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height*0.03,
                          // color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        // backgroundColor: Colors.red,
                          foregroundColor: Colors.red
                      ),
                      onPressed: () {
                        // cubit.deleteCharacter(index , context);
                        CharacterCubit.get(context).deleteMessages(context ,receiverId: widget.receiverId, date: model.dateTime);
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height*0.03,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    ),
                  ],
                );
              }
          );

        },
        icon: IconBroken.Delete,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.red,
        autoClose: true,
        padding: EdgeInsets.fromLTRB(0, 0, 5, 10),
      ),
    ],
  ),


  child:   Column(
    children: [
          Align(
        alignment: AlignmentDirectional.centerStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsetsDirectional.only(
                top: MediaQuery.of(context).size.height*0.0015,
                bottom: MediaQuery.of(context).size.height*0.0015,
                end: MediaQuery.of(context).size.width*0.25,
              ),

              child:
              Container(
                // height: MediaQuery.of(context).size.height*0.2,

                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: FullScreenWidget(
                    child:
                    // Image(
                    //   image:NetworkImage(
                    //     '${model.messageImage}',
                    //   ) ,
                    //   fit: BoxFit.fitWidth,
                    // ),
                  cachedImage(image:  '${model.messageImage}' , height: MediaQuery.of(context).size.height*0.2),

                  ),
                ),
              ),
            ),

            if(! model.text!.trim().isEmpty)
              SizedBox(height: 4,),

            if(! model.text!.trim().isEmpty)
              Container(
              padding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: defaultGrey.withOpacity(0.25),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: SelectableText(
                '${model.text}' ,
                // 'loool' ,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height*0.022,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  height: 1.1,
                  color: Colors.black.withOpacity(0.75),
                ),
              ),
            ),

            Padding(

              padding: const EdgeInsetsDirectional.only(
                top: 2,
                start: 3,
              ),
              child: Text(
                '${DateFormat.jm().format(DateTime.parse(model.dateTime!))}',
                style: Theme.of(context).textTheme.caption!.copyWith(
                    fontSize: MediaQuery.of(context).size.height*0.011,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
}
