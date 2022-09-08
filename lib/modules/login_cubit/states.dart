abstract class LoginStates{}

class LoginInitialState extends LoginStates{}

class ChangePasswordVisibility extends LoginStates{}

class LoginLoadingState extends LoginStates{}

class LoginSuccessState extends LoginStates{
  final String uId ;
  LoginSuccessState(this.uId) ;
}

class LoginErrorState extends LoginStates{
  final String error ;
  LoginErrorState(this.error) ;
}

class RegisterLoadingState extends LoginStates{}

class RegisterSuccessState extends LoginStates{}

class RegisterErrorState extends LoginStates{
  final String error ;
  RegisterErrorState(this.error) ;
}

class CreateUserLoadingState extends LoginStates{}

class CreateUserSuccessState extends LoginStates{
  final String uId ;
  CreateUserSuccessState(this.uId) ;
}

class CreateUserErrorState extends LoginStates{
  final String error ;
  CreateUserErrorState(this.error) ;
}



// class LoginCreateDatabaseState extends LoginStates{}
//
// class LoginGetDatabaseState extends LoginStates{}
//
// class LoginGetDatabaseLoadingState extends LoginStates{}
//
// class LoginInsertDatabaseState extends LoginStates{}
//
// class LoginUpdateDatabaseState extends LoginStates{}
//
// class LoginDeleteDatabaseState extends LoginStates{}