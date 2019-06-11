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
      sink.addError("Password should be atleast 8 characters long");
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
    return username.toLowerCase().contains("abc");
  }

  static bool passwordConditionChecker(String password) {
    return password.toLowerCase().contains("abc") || password.length >= 8;
  }
}
