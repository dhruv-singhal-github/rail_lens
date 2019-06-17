import 'dart:async';

mixin Validator {
  //TODO: Sort this mess out
  var usernameValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) {
    if (usernameConditionChecker(username)) {
      sink.add(username);
    } else {
      sink.addError("Invalid Username");
    }
  });

  var passwordValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    if (passwordConditionChecker(pass)) {
      sink.add(pass);
    } else {
      sink.addError("Invalid Password");
    }
  });

  var confPassValidator =
      StreamTransformer<List<Object>, List<Object>>.fromHandlers(
        handleData: (passList, sink){
          if(Validator.passwordConditionChecker(passList[1] as String))
            {
              if( (passList[1] as String) == (passList[2] as String) ){
                List<Object> list = List<Object>.from(passList);
                list.add(true);
                sink.add(list);
              } else{
                sink.addError("Passwords do not match");
              }
            } else {
            List<Object> list = List<Object>.from(passList);
            list.add(false);
            sink.add(list);
          }

        }
      );

  static bool usernameConditionChecker(String username) {
    //TODO: Protect against injection
    return !username.contains("&") && username.isNotEmpty && !username.contains(':') ;
  }

  static bool passwordConditionChecker(String password) {
    //TODO: Protect against injection
    return !password.contains(':') && password.isNotEmpty;
  }
}
