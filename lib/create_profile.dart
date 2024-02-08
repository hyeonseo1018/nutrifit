import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutrifit/Loginpage.dart';
import 'main.dart';

class create_profile extends StatefulWidget {
  String username = '';
  create_profile({required this.username});
  @override
  State<create_profile> createState() => _create_profileState(username : username);
}

class _create_profileState extends State<create_profile> {
  String username = '';
  _create_profileState({required this.username});
  double pal_value = 1.2;
  String gender_value = '남';
  final TextEditingController weightcontroller = TextEditingController();
  final TextEditingController heightcontroller = TextEditingController();

  Future<void> _createprofile(context) async {
    final String url =
        'https://nutrifit-server-h52zonluwa-du.a.run.app/users/signup';
    final data = {
      'user_id': username,
      'gender': gender_value,
      'weight': weightcontroller.text,
      'height': heightcontroller.text,
      'pal_value': pal_value,
    };

    final http.Response response = await http.post(
      Uri.parse(url),
      body: data,
    );

    if (response.statusCode != 201) {
      print('회원가입을 다시 시도해 주세요 ${response.statusCode}');
    } else {
      print('회원가입 성공');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Loginpage()));
      //navigator > 로그인 창으로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    List gender = [
      {'label': '남자', 'value': '남'},
      {'label': '여자', 'value': '여'},
    ];
    List pal = [
      {'label': '약한 활동', 'value': 1.2},
      {'label': '가벼운 활동(주1-3회 가벼운 운동)', 'value': 1.375},
      {'label': '보통 활동(주3-5회 운동)', 'value': 1.55},
      {'label': '활발한 활동(주5회 이상 강도 높은 운동)', 'value': 1.725},
      {'label': '매우 활동적임(주7회 강도 높은 운동)', 'value': 1.9},
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 정보 입력'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('    성별을 선택해주세요!'),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: gender.length,
                itemBuilder: (BuildContext context, int index) {
                  return RadioListTile<String>(
                      title: Text(gender[index]['label']),
                      value: gender[index]['value'],
                      groupValue: gender_value,
                      onChanged: (value) {
                        setState(() {
                          gender_value = value ?? '';
                          print(gender_value);
                        });
                      });
                }),
            SizedBox(
              height: 30,
            ),
            Container(
              color: Color.fromARGB(255, 211, 210, 210),
              height: 7,
            ),
            SizedBox(
              height: 30,
            ),
            Text('   체중과 키 정보를 작성해주세요!'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('체중'),
                SizedBox(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: weightcontroller,
                          decoration: InputDecoration(
                              errorText:
                                  weightcontroller.text == '' ? '필수 정보' : null),
                        ),
                      ),
                      Text('kg')
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('키'),
                SizedBox(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: TextField(
                          controller: heightcontroller,
                          decoration: InputDecoration(
                              errorText:
                                  weightcontroller.text == '' ? '필수 정보' : null),
                        ),
                      ),
                      Text('kg')
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              color: Color.fromARGB(255, 211, 210, 210),
              height: 7,
            ),
            SizedBox(
              height: 30,
            ),
            Text('   활동 정도를 선택해주세요!'),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: pal.length,
                itemBuilder: (BuildContext context, int index) {
                  return RadioListTile<double>(
                      title: Text(pal[index]['label']),
                      value: pal[index]['value'],
                      groupValue: pal_value,
                      onChanged: (value) {
                        setState(() {
                          pal_value = value ?? 0.0;
                          print(pal_value);
                        });
                      });
                }),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (weightcontroller.text != '' &&
                        heightcontroller.text != '') {
                      _createprofile(context);
                    } else {
                      print('필수 정보 입력 필요');
                    }
                  },
                  child: Text('회원가입 완료하기')),
            )
          ],
        ),
      ),
    );
  }
}
