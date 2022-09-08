class UserDataModel{

  String ? name ;
  String ? phone ;
  String ? email ;
  String ? password ;
  String ? uId ;
  String ? image ;
  String ? cover ;
  String ? bio ;

  UserDataModel({
    this.name,
    this.phone,
    this.email,
    this.password,
    this.uId,
    this.image,
    this.cover,
    this.bio,
  }) ;

  UserDataModel.fromJson(Map<String , dynamic> json)
  {
    name = json['name'] ;
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    uId = json['uId'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
  }


  Map<String , dynamic> toMap(){

    return{
      'name' : name ,
      'phone' : phone ,
      'email' : email,
      'password' : password,
      'uId' : uId,
      'image' : image,
      'cover' : cover,
      'bio' : bio,
    };
  }



}