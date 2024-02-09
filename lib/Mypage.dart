import 'dart:convert';
import 'create_profile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'main.dart';
import 'Loginpage.dart';

class Mypage extends StatefulWidget {
  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  bool edit = false;

  Future<void> delete(context) async {
    await storage.deleteAll();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Loginpage()));
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

  Future<void> info_update(info) async {
    final url = Uri.parse(
        'https://nutrifit-server-h52zonluwa-du.a.run.app/users/update');
    await http.patch(url,
        body: jsonEncode({
          'water': 'user_id',
          'protein': 'user_password',
          'mineral': 'user_name',
          'fat': 'user_age',
          'weight': '',
          'muscle': ''
        }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _info(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final list = jsonDecode(snapshot.data);
          final TextEditingController weightcontroller =
              TextEditingController(text: list['water'] != null ? list['water'].toString() : '');//weight 로 변경
          final TextEditingController heightcontroller =
              TextEditingController();  // text: list['height']!.toString()

          return Center(
            child: SingleChildScrollView(
              child: Column(children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        edit = !edit;
                      });
                    },
                    child: edit == false ? Text('수정하기') : Text('완료하기')),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('체중'),
                                SizedBox(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 30, child: TextField(
                                        enabled: edit,
                                        controller: weightcontroller,
                                      )),
                                      Text('kg')
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 15,),
                          Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('키'),
                                SizedBox(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 30, child: TextField(
                                        controller: heightcontroller,
                                        enabled: edit,
                                      )),
                                      Text('cm')
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(width: double.infinity),
                ),
                ElevatedButton(
                    onPressed: () {
                      delete(context);
                    },
                    child: Text('로그아웃')),
              ]),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('error');
        }
        return CircularProgressIndicator();
      },
    );
  }
}
