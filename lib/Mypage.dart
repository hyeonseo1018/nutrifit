
import 'package:flutter/material.dart';
import 'package:nutrifit/main.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Mypage extends StatelessWidget{

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    final String url = 'https://nutrifit-server-h52zonluwa-du.a.run.app/signin';
    final Map<String, String> data = {
      'user_id': usernameController.text,
      'user_password': passwordController.text,
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      body: data,
    );

    if (response.statusCode == 201) {

      var list = response.body;
      print(list);
      print('로그인 성공');
      // TODO: JWT 토큰을 저장하거나 다른 처리 수행
    } else {
      // 로그인 실패 시
      print('로그인 실패: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context){

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'id'),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'password'),
              ),
            ),
          ),
          ElevatedButton(onPressed: (){_login();}, child: Text('로그인'))

      ]),
    );
  }
}