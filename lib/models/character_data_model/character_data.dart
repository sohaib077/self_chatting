class CharacterDataModel{

  String ? name ;
  // String ? uId ;
  String ? image ;
  String ? cover ;
  String ? bio ;
  String ? date ;
  String ? type ;

  CharacterDataModel({
    this.name,
    // this.uId,
    this.image,
    this.cover,
    this.bio,
    this.date,
    this.type,
  }) ;

  CharacterDataModel.fromJson(Map<String , dynamic> json)
  {
    name = json['name'] ;
    // uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    date = json['date'];
    type = json['type'];
  }


  Map<String , dynamic> toMap(){

    return{
      'name' : name ,
      // 'uId' : uId,
      'image' : image,
      'cover' : cover,
      'bio' : bio,
      'date' : date,
      'type' : type,
    };
  }



}