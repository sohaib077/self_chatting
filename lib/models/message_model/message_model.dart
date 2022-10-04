class MessageModel{

  String ? text ;
  String ? dateTime ;
  String ? senderId ;
  String ? receiverId ;
  String ? messageImage ;



  MessageModel({
    this.dateTime ,
    this.senderId ,
    this.receiverId ,
    this.text,
    this.messageImage,
  });

  MessageModel.fromJson(Map<String , dynamic> json){
    text = json['text'];
    dateTime = json['dateTime'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    messageImage = json['messageImage'];
  }

  Map< String , dynamic> toMap(){
    return{
      'senderId' : senderId ,
      'text' : text ,
      'dateTime' : dateTime ,
      'receiverId' : receiverId ,
      'messageImage' : messageImage ,

    };
  }


}