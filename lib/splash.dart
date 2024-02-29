import 'dart:async';

import 'package:db_practice/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashSc extends StatefulWidget{

  @override
  State<SplashSc> createState() => _SplashScState();
}

class _SplashScState extends State<SplashSc> {
  void initState(){
    super.initState();
    splashTime();
  }

  void splashTime(){
    Timer(Duration(seconds: 3), () async{

      SharedPreferences pref = await SharedPreferences.getInstance();
      String? unique_Id = pref.getString('unique_Id');
      String? username = pref.getString('username');

      if(unique_Id != null){
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomeSc(username:username),));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp(),));
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red,),
    );
  }
}