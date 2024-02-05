

import 'package:flutter/material.dart';
import 'main.dart';
import 'Loginpage.dart';

class Mypage extends StatelessWidget{

  Future<void> delete(context) async {
    await storage.deleteAll();  
    Navigator.push(context,MaterialPageRoute(builder: (context) =>  Loginpage()));
  }
  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        children: [
          ElevatedButton(onPressed: (){delete(context);}, child: Text('로그아웃'))
          ]),
    );
  }
}