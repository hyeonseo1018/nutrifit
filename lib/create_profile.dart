import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutrifit/Homepage.dart';
import 'package:nutrifit/Loginpage.dart';
import 'package:nutrifit/MyHomePage.dart';
import 'package:nutrifit/mypage.dart';
import 'main.dart';

class create_profile extends StatefulWidget {
  String navigator = '';
  create_profile({required this.navigator});
  @override
  State<create_profile> createState() =>
      _create_profileState(navigator: navigator);
}

class _create_profileState extends State<create_profile> {
  String navigator = '';
  _create_profileState({required this.navigator});

  double pal_value = 1.2;
  String gender_value = '남';
  TextEditingController weightcontroller = TextEditingController();
  TextEditingController heightcontroller = TextEditingController();

  Future<void> _createprofile(context) async {
    final String url =
        'https://nutrifit-server-h52zonluwa-du.a.run.app/users/update';
    final weight = double.parse(weightcontroller.text);
    final height = double.parse(heightcontroller.text);

    final data = {
      'height': height,
      'weight': weight,
      'age': 0,
      'activity': pal_value,
      'gender': gender_value,
      "todays": "",
      "today_energy": 0,
      "today_water": 0,
      "today_protein": 0,
      "today_fat": 0,
      "today_carbohydrate": 0
    };
    String jsonString = json.encode(data);
    final http.Response response =
        await http.patch(Uri.parse(url), body: jsonString, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer ${await storage.read(key: 'jwtToken')}'
    });

    if (response.statusCode != 200) {
      print('update를 다시 시도해 주세요 ${response.statusCode}');
    } else {
      print('update 성공');
      if (navigator == 'tologin') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Loginpage()));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      selectedIndex: 2,
                    )));
      }
      //navigator > 로그인 창으로 이동
    }
  }

  Future _info() async {
    final response = await http.get(
        Uri.parse(
            'https://nutrifit-server-h52zonluwa-du.a.run.app/users/profile'),
        headers: {
          'Authorization': 'Bearer ${await storage.read(key: 'jwtToken')}'
        });
    return response.body;
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
    return FutureBuilder(
        future: _info(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = jsonDecode(snapshot.data);
            gender_value = (list["gender"]??'');
            weightcontroller.text = (list['weight']??'').toString();
            heightcontroller.text = (list['height']?? '').toString();
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
                                      errorText: weightcontroller.text == ''
                                          ? '필수 정보'
                                          : null),
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
                                      errorText: weightcontroller.text == ''
                                          ? '필수 정보'
                                          : null),
                                ),
                              ),
                              Text('cm')
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
                          child: Text('완료하기')),
                    )
                  ],
                ),
              ),
            );
          }else if (snapshot.hasError) {
          return Text('error');
        }
        return CircularProgressIndicator();
        });
  }
}
