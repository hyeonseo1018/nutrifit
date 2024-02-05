
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nutrifit/MyHomePage.dart';
import 'main.dart';
import 'package:get/get.dart';


class Loginpage extends StatelessWidget{


  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final sharedStorage = storage;


  Future<void> _saveToken(String token) async {
    await storage.write(key: 'jwtToken', value: token);
   
  }

  Future<void> _login(context) async {
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
      
      _saveToken(response.body);
      print('로그인 성공');
      Navigator.push(context,MaterialPageRoute(builder: (context) =>  MyHomePage()));
      // TODO: JWT 토큰을 저장하거나 다른 처리 수행
    } else {
      // 로그인 실패 시
      print('로그인 실패: ${response.reasonPhrase}');
    }
  }
  

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(title: Center(child: Text('로그인하기'),),
      automaticallyImplyLeading: false,),
      body: Column(
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(onPressed: (){_login(context);}, child: Text('로그인')),
              TextButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context) =>  Signuppage()));}, child: Text('회원가입하기'))
            ],
          ),
          


      ]),
    );
  }
}

class Signuppage extends StatelessWidget{
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  
  Future<void> _signup() async {
    final String url = 'https://nutrifit-server-h52zonluwa-du.a.run.app/signup';
    final Map<String, String> data = {
      'user_id': usernameController.text,
      'user_password': passwordController.text,
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      body: data,
    );

    if (response.statusCode == 201) {

      print('로그인 성공');
      // TODO: JWT 토큰을 저장하거나 다른 처리 수행
    } else {
      // 로그인 실패 시
      print('로그인 실패: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context){
   return Scaffold(
    appBar: AppBar(title: Text('회원가입하기'),),
    body: Center(

    ),
   );
  }
}