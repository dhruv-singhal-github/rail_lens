import 'dart:async';
mixin Validator{

  //TODO: Sort this mess out
  var usernameValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (username, sink){
      if(usernameConditionChecker(username)){
        sink.add(username);
      } else{
        sink.addError("Invalid Username");
      }
    }
  );

  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (pass, sink){
        if(passwordConditionChecker(pass)){
          sink.add(pass);
        } else{
          sink.addError("Password should be atleast 8 characters long");
        }
      }
  );

  static bool usernameConditionChecker(String username){
    return username.toLowerCase().contains("abc");
  }

  static bool passwordConditionChecker(String password){
    return password.toLowerCase().contains("abc") || password.length>=8;
  }

}