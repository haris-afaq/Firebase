import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/view/auth/login.dart';
import 'package:firebase_practice/view/google_maps/mapBox_map.dart';

import 'package:flutter/material.dart';

class SplashScreenServices {

  void isLogin(BuildContext context){
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
      Timer((Duration(seconds: 5)), (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>
    MapboxMapScreen()
    ));
   }); 
    }
  else{
     Timer((Duration(seconds: 5)), (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>
    Login()
    ));
   }); 
  }
  }
}