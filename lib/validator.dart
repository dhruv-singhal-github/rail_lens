import 'dart:async';
mixin Validator{

  var usernameValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (username, sink){
      if(username.toLowerCase().contains("abc")){
        sink.add(username);
      } else{
        sink.addError("Invalid Username");
      }
    }
  );

  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (pass, sink){
        if(pass.toLowerCase().contains("sarth") || pass.length>=8){
          sink.add(pass);
        } else{
          sink.addError("Password should be atleast 8 characters long");
        }
      }
  );
}