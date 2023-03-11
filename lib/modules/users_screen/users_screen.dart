import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting/main.dart';
import 'package:chatting/models/character_data_model/character_data.dart';
import 'package:chatting/modules/character_cubit/character_cubit.dart';
import 'package:chatting/modules/character_cubit/character_states.dart';
import 'package:chatting/modules/create_character_screen/create_character_screen.dart';
import 'package:chatting/shared/components/components.dart';
import 'package:chatting/update_character_screen/update_character_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../shared/components/constants.dart';
import '../../shared/remote/cache_helper.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/icon_broken.dart';
import '../login_screen/login_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    var screenHeight =  MediaQuery.of(context).size.height ;
    var screenWidth =  MediaQuery.of(context).size.width ;

    return BlocConsumer<CharacterCubit , CharacterStates>(
      listener: (context , state){
        if(state is DeleteCharactersSuccessState)
          Navigator.pop(context);
      },
      builder: (context , state){

        var cubit = CharacterCubit.get(context) ;
        var profileImage = CharacterCubit.get(context).characterProfileImage ;
        var coverImage = CharacterCubit.get(context).characterCoverImage ;


        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },

          child: Scaffold(
              floatingActionButton:
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  bottom: 10 ,
                  end: 10,
                ),
                child: FloatingActionButton(
                  heroTag: 'create',
                  onPressed: (){
                    // cubit.numberOfChats();
                    cubit.characterProfileImage = null ;
                    cubit.characterCoverImage = null ;
                    navigateTo(context, CreateCharacterScreen(), x: 0 , y: 1);
                  },
                  child: Icon(
                    IconBroken.Plus,
                    size: screenHeight*0.04,
                  ),
                  backgroundColor: defaultTealAccent,
                  elevation: 3,
                  highlightElevation: 0,
                  splashColor: Colors.tealAccent.withOpacity(0.5),

                ),


              ),

              body: NestedScrollView(
                physics: BouncingScrollPhysics(),
                floatHeaderSlivers: true,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    title: Text(
                      'Characters',
                    ),
                    systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent.withOpacity(0.05),
                        statusBarIconBrightness: Brightness.dark,
                        statusBarBrightness: Brightness.dark
                    ),
                    forceElevated: true,
                    elevation: 5,
                    shadowColor: defaultGrey.withOpacity(0.5),
                    toolbarHeight: screenHeight*0.07,
                   ),
                  ];
               },
            body: ConditionalBuilder(
                 condition: cubit.charModel.length > 0,
                  builder: (context) =>
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 0.0 ,),
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                        itemBuilder: (context , index) => Column(
                          children: [
                            // if(index == 0)
                            //   SizedBox(height: screenHeight*0.025,),

                            Slidable(
                              endActionPane:  ActionPane(
                              extentRatio: 0.5,
                                motion: StretchMotion(),
                                children: [
                                  SlidableAction(
                                borderRadius: BorderRadius.circular(15),
                                icon: IconBroken.Delete,
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.red,
                                autoClose: true,
                                label: 'Delete Character',
                                spacing: 10,

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
                                            'All of messages with this character will be deleted.',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                              height: 1.25,
                                            ),
                                          ),
                                          contentPadding: EdgeInsetsDirectional.only(
                                            start: 30,
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
                                                  fontSize: screenHeight*0.03,
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
                                                cubit.deleteCharacter(index , context);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontSize: screenHeight*0.03,
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
                              ),
                            ]
                          ),

                                child: characterItem(context , index , cubit.charModel[index])
                            ),
                            if(index == CharacterCubit.get(context).charSize!-1)
                              SizedBox(height: MediaQuery.of(context).size.height*0.15,)
                          ],
                        ),
                        separatorBuilder: (context , index) => SizedBox(height: screenHeight*0.025,),
                        itemCount: cubit.charSize!,
                    ),
                  ),

                  fallback: (context) =>Center(child: CircularProgressIndicator(
                    color: defaultTealAccent,
                  )) ,
                ),
              ),
          ),
        );
      },
    );
  }

  Widget characterItem(context , index , CharacterDataModel charModel)=> Padding(
    padding: const EdgeInsets.all(0.0),
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
                offset: Offset(0,2),
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
                    radius: MediaQuery.of(context).size.height*0.038,
                    backgroundImage:   CachedNetworkImageProvider(
                      // 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&uid=R61521309&ga=GA1.2.1730070774.1650502465',
                      '${charModel.image}',
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*0.03,),
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
                        fontSize: MediaQuery.of(context).size.height*0.028,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      '${charModel.bio}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize:MediaQuery.of(context).size.width*0.032,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Spacer() ,
                // IconButton(
                //     onPressed: (){},
                //     icon: Icon(
                //       IconBroken.Edit,
                //       size: MediaQuery.of(context).size.height*0.04,
                //     ),
                // ),
                FloatingActionButton(
                  heroTag: 'Char ${index.toString}',
                  onPressed: (){
                    CharacterCubit.get(context).characterProfileImage = null ;
                    CharacterCubit.get(context).characterCoverImage = null ;
                    print(CharacterCubit.get(context).charId[index]);
                    // CharacterCubit.get(context).deleteImages('cover', index);
                    CharacterCubit.get(context).controller = 0;
                     navigateTo( context, UpdateCharacterScreen(charModel , CharacterCubit.get(context).charId[index] , index) );
                  },
                  child: Icon(
                    IconBroken.Edit,
                    size: MediaQuery.of(context).size.height*0.04,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  highlightElevation: 0,
                  splashColor: Colors.tealAccent.withOpacity(0.5),

                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

}
