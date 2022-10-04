import 'package:chatting/modules/character_cubit/character_cubit.dart';

import 'package:chatting/modules/character_cubit/character_cubit.dart';

import 'package:chatting/modules/character_cubit/character_cubit.dart';

abstract class CharacterStates {}

class CharacterInitialState extends CharacterStates {}

class CharacterProfileImagePickedSuccessState extends CharacterStates {}
class CharacterCoverImagePickedSuccessState extends CharacterStates {}
class CharacterCroppedImagePickedSuccessState extends CharacterStates {}

class CreateCharacterLoadingState extends CharacterStates {}
class CreateCharacterSuccessState extends CharacterStates {}
class CreateCharacterErrorState extends CharacterStates {}

class GetCharactersLoadingState extends CharacterStates {}
class GetCharactersSuccessState extends CharacterStates {}
class GetCharactersErrorState extends CharacterStates {}

class DeleteCharactersLoadingState extends CharacterStates {}
class DeleteCharactersSuccessState extends CharacterStates {}
class DeleteCharactersErrorState extends CharacterStates {}

class CheckLoadingState extends CharacterStates {}
class CheckSuccessState extends CharacterStates {}
class CheckErrorState extends CharacterStates {}


class SendMessageSuccessState extends CharacterStates{}
class SendMessageErrorState extends CharacterStates{}
class GetMessagesSuccessState extends CharacterStates{}
class GetMessagesLoadingState extends CharacterStates{}

class GetMostChattingSuccessState extends CharacterStates{}
class GetNumberOfChatsSuccessState extends CharacterStates{}


class GetLastMessagesLoadingState extends CharacterStates{}
class GetLastMessagesSuccessState extends CharacterStates{}

class DeleteMessageSuccessState extends CharacterStates{}
class DeleteMessageLoadingState extends CharacterStates{}

class DeleteConversationSuccessState extends CharacterStates{}
class DeleteConversationLoadingState extends CharacterStates{}

class DeletingLoadingState extends CharacterStates{}


class UploadMessageImageLoadingState extends CharacterStates{}
class UploadMessageImageErrorState extends CharacterStates{}
class UploadMessageImageSuccessState extends CharacterStates{}


class MessageImagePickedSuccessState extends CharacterStates{}
class MessageImagePickedErrorState extends CharacterStates{}

class RemoveMessageImageState extends CharacterStates{}

class SwitchSenderState extends CharacterStates{}
class SwitchColorState extends CharacterStates{}

class SendCharMessageSuccessState extends CharacterStates{}
class SendCharMessageErrorState extends CharacterStates{}

class UpdateCharacterAllOfThemLoadingState extends CharacterStates {}
class UpdateCharacterAllOfThemSuccessState extends CharacterStates {}
class UpdateCharacterAllOfThemErrorState extends CharacterStates {}

class UpdateCharacterLoadingState extends CharacterStates {}
class UpdateCharacterSuccessState extends CharacterStates {}
class UpdateCharacterErrorState extends CharacterStates {}

class UpdateCharacterProfileSuccessState extends CharacterStates {}
class UpdateCharacterProfileErrorState extends CharacterStates {}

class UpdateCharacterCoverSuccessState extends CharacterStates {}
class UpdateCharacterCoverErrorState extends CharacterStates {}

class DeleteSuccessState extends CharacterStates {}
class DeleteErrorState extends CharacterStates {}

class ChangeAvatarIndexSuccesState extends CharacterStates {}





