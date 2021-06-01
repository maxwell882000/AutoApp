
import 'dart:convert';


import 'package:flutter/material.dart';


import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonRecomendation.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:flutter_projects/helper_clesses/TextInput/TextInputForum.dart';
import 'package:flutter_projects/provider/ErrorMessageProvider.dart';

import 'package:http/http.dart' as http;
class LogIn extends StatelessWidget {
 LogIn({Key key}) : super(key: key);

 Function clickLogin(BuildContext context) {
   return (String emailOrPhone, String provider,
       ErrorMessageProvider prov) async {
     final http.Response response = await http.post(
         '${SingletonConnection.URL}/login/',
         headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
         },
         body: jsonEncode(<String, String>{
           'emailOrPhone': emailOrPhone,
           'provider': provider
         }));
     var resultOfResponse = jsonDecode(response.body);
     print(resultOfResponse);
     if (resultOfResponse[1] == 200) {
       Map json = jsonDecode(response.body)[0];
       SingletonUserInformation()
           .setEmailOrPhone(json["emailOrPhone"]);

      SingletonConnection().authorizedData().then((value) {
        final res = Navigator.of(context).popAndPushNamed('/authorized');
        res.then((value) {
          print("LOG OUT");
          SingletonUserInformation().clean();
          SingletonRecomendation().clean();
        });
      });

     } else {
       prov.setNextPage(false);
       prov.setError(true);
       prov.setNameOfHelper("Аккаунт с такими данными не существует");
     }
   };
 }
  @override
  Widget build(BuildContext context) {


    return TextInputForum(
      svgPicture:"assets/registration.svg",
      aboveText: "Войти в аккаунт",
      nameOfButton: "Войти",
      connectDataBase: clickLogin(context),
    );
  }
}
